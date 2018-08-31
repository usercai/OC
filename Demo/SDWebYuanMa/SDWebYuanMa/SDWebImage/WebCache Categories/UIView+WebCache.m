/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

NSString * const SDWebImageInternalSetImageGroupKey = @"internalSetImageGroup";
NSString * const SDWebImageExternalCustomManagerKey = @"externalCustomManager";

const int64_t SDWebImageProgressUnitCountUnknown = 1LL;

static char imageURLKey;

#if SD_UIKIT
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;
#endif

@implementation UIView (WebCache)

- (nullable NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (NSProgress *)sd_imageProgress {
    NSProgress *progress = objc_getAssociatedObject(self, @selector(sd_imageProgress));
    if (!progress) {
        progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
        self.sd_imageProgress = progress;
    }
    return progress;
}

- (void)setSd_imageProgress:(NSProgress *)sd_imageProgress {
    objc_setAssociatedObject(self, @selector(sd_imageProgress), sd_imageProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sd_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable SDExternalCompletionBlock)completedBlock {
    return [self sd_internalSetImageWithURL:url placeholderImage:placeholder options:options operationKey:operationKey setImageBlock:setImageBlock progress:progressBlock completed:completedBlock context:nil];
}


/**
 请求图片

 @param url 图片网址
 @param placeholder 默认图
 @param options 加载模式
 @param operationKey <#operationKey description#>
 @param setImageBlock <#setImageBlock description#>
 @param progressBlock 进度回调
 @param completedBlock <#completedBlock description#>
 @param context <#context description#>
 */
- (void)sd_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable SDExternalCompletionBlock)completedBlock
                           context:(nullable NSDictionary<NSString *, id> *)context {
    /// 每一个view都给他绑定一个operation，通过一个key来获取这个operation
    /// 如果operationKey为nil，就采用他自身的类的字符串作为key
    NSString *validOperationKey = operationKey ?: NSStringFromClass([self class]);
    /// 这是一个view的分类方法，目的是取消之前绑定的operation,这就是UITableViewCell重用后，快速滑动时，中间部分的图片不会被下载的原因。
    [self sd_cancelImageLoadOperationWithKey:validOperationKey];
    //绑定url,每一个请求的对象都绑定自己的url
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //判断options 是否等于 SDWebImageDelayPlaceholder 是否设置默认图片模式
    if (!(options & SDWebImageDelayPlaceholder)) {
        //默认为空  不走这里
        if ([context valueForKey:SDWebImageInternalSetImageGroupKey]) {
            //获取线程
            dispatch_group_t group = [context valueForKey:SDWebImageInternalSetImageGroupKey];
            //放到线程池中
            dispatch_group_enter(group);
        }
        //主线程  设置默认图等待加载图片 如果没有加载图片(setImageBlock默认为nil)显示默认图
        dispatch_main_async_safe(^{
            [self sd_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:setImageBlock];
        });
    }
    
    if (url) {
#if SD_UIKIT
        //// check if activityView is enabled or not
        //如果UIImageView对象有设置添加转动菊花数据，加载的时候添加转动的菊花
        if ([self sd_showActivityIndicatorView]) {
            [self sd_addActivityIndicator];
        }
#endif
        
        // reset the progress
        //重置进度  系统progress进度条
        //总单元, 用来记载某个任务的总单元数
        self.sd_imageProgress.totalUnitCount = 0;
        //已完成单元数量
        self.sd_imageProgress.completedUnitCount = 0;
        
        SDWebImageManager *manager;
        //context默认为空
        if ([context valueForKey:SDWebImageExternalCustomManagerKey]) {
            manager = (SDWebImageManager *)[context valueForKey:SDWebImageExternalCustomManagerKey];
        } else {
            //初始化
            manager = [SDWebImageManager sharedManager];
        }
        
        __weak __typeof(self)wself = self;
        SDWebImageDownloaderProgressBlock combinedProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            //expectedSize 总大小  receivedSize当前大小  targetURL网址
            wself.sd_imageProgress.totalUnitCount = expectedSize;
            wself.sd_imageProgress.completedUnitCount = receivedSize;
            if (progressBlock) {
                progressBlock(receivedSize, expectedSize, targetURL);
            }
        };
        id <SDWebImageOperation> operation = [manager loadImageWithURL:url options:options progress:combinedProgressBlock completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong __typeof (wself) sself = wself;
            if (!sself) { return; }
#if SD_UIKIT
            //移除小菊花
            [sself sd_removeActivityIndicator];
#endif
            //如果进度未更新，请将其标记为完整状态。
            // if the progress not been updated, mark it to complete state
            if (finished && !error && sself.sd_imageProgress.totalUnitCount == 0 && sself.sd_imageProgress.completedUnitCount == 0) {
                sself.sd_imageProgress.totalUnitCount = SDWebImageProgressUnitCountUnknown;
                sself.sd_imageProgress.completedUnitCount = SDWebImageProgressUnitCountUnknown;
            }
            BOOL shouldCallCompletedBlock = finished || (options & SDWebImageAvoidAutoSetImage);
            BOOL shouldNotSetImage = ((image && (options & SDWebImageAvoidAutoSetImage)) ||
                                      (!image && !(options & SDWebImageDelayPlaceholder)));
            SDWebImageNoParamsBlock callCompletedBlockClojure = ^{
                if (!sself) { return; }
                if (!shouldNotSetImage) {
                    [sself sd_setNeedsLayout];
                }
                if (completedBlock && shouldCallCompletedBlock) {
                    completedBlock(image, error, cacheType, url);
                }
            };
            
            // case 1a: we got an image, but the SDWebImageAvoidAutoSetImage flag is set
            // OR
            // case 1b: we got no image and the SDWebImageDelayPlaceholder is not set
            if (shouldNotSetImage) {
                dispatch_main_async_safe(callCompletedBlockClojure);
                return;
            }
            
            UIImage *targetImage = nil;
            NSData *targetData = nil;
            if (image) {
                // case 2a: we got an image and the SDWebImageAvoidAutoSetImage is not set
                targetImage = image;
                targetData = data;
            } else if (options & SDWebImageDelayPlaceholder) {
                // case 2b: we got no image and the SDWebImageDelayPlaceholder flag is set
                targetImage = placeholder;
                targetData = nil;
            }
            
#if SD_UIKIT || SD_MAC
            // check whether we should use the image transition
            SDWebImageTransition *transition = nil;
            if (finished && (options & SDWebImageForceTransition || cacheType == SDImageCacheTypeNone)) {
                transition = sself.sd_imageTransition;
            }
#endif
            if ([context valueForKey:SDWebImageInternalSetImageGroupKey]) {
                dispatch_group_t group = [context valueForKey:SDWebImageInternalSetImageGroupKey];
                dispatch_group_enter(group);
                dispatch_main_async_safe(^{
#if SD_UIKIT || SD_MAC
                    [sself sd_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock transition:transition cacheType:cacheType imageURL:imageURL];
#else
                    [sself sd_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock];
#endif
                });
                // ensure completion block is called after custom setImage process finish
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    callCompletedBlockClojure();
                });
            } else {
                dispatch_main_async_safe(^{
#if SD_UIKIT || SD_MAC
                    [sself sd_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock transition:transition cacheType:cacheType imageURL:imageURL];
#else
                    [sself sd_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock];
#endif
                    callCompletedBlockClojure();
                });
            }
        }];
        [self sd_setImageLoadOperation:operation forKey:validOperationKey];
    } else {
        dispatch_main_async_safe(^{
#if SD_UIKIT
            [self sd_removeActivityIndicator];
#endif
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:NSStringFromClass([self class])];
}

- (void)sd_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(SDSetImageBlock)setImageBlock {
#if SD_UIKIT || SD_MAC
    [self sd_setImage:image imageData:imageData basedOnClassOrViaCustomSetImageBlock:setImageBlock transition:nil cacheType:0 imageURL:nil];
#else
    // watchOS does not support view transition. Simplify the logic
    if (setImageBlock) {
        setImageBlock(image, imageData);
    } else if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        [imageView setImage:image];
    }
#endif
}
//SDSetImageBlock //_Nullable  不能为空
//typedef void(^SDSetImageBlock)(UIImage * _Nullable image, NSData * _Nullable imageData);
#if SD_UIKIT || SD_MAC
- (void)sd_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(SDSetImageBlock)setImageBlock transition:(SDWebImageTransition *)transition cacheType:(SDImageCacheType)cacheType imageURL:(NSURL *)imageURL {
    UIView *view = self;
    SDSetImageBlock finalSetImageBlock;
    if (setImageBlock) {
        finalSetImageBlock = setImageBlock;
    } else if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view;
        finalSetImageBlock = ^(UIImage *setImage, NSData *setImageData) {
            imageView.image = setImage;
        };
    }
#if SD_UIKIT
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        finalSetImageBlock = ^(UIImage *setImage, NSData *setImageData){
            [button setImage:setImage forState:UIControlStateNormal];
        };
    }
#endif
    
    if (transition) {
#if SD_UIKIT
        [UIView transitionWithView:view duration:0 options:0 animations:^{
            // 0 duration to let UIKit render placeholder and prepares block
            if (transition.prepares) {
                transition.prepares(view, image, imageData, cacheType, imageURL);
            }
        } completion:^(BOOL finished) {
            [UIView transitionWithView:view duration:transition.duration options:transition.animationOptions animations:^{
                if (finalSetImageBlock && !transition.avoidAutoSetImage) {
                    finalSetImageBlock(image, imageData);
                }
                if (transition.animations) {
                    transition.animations(view, image);
                }
            } completion:transition.completion];
        }];
#elif SD_MAC
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull prepareContext) {
            // 0 duration to let AppKit render placeholder and prepares block
            prepareContext.duration = 0;
            if (transition.prepares) {
                transition.prepares(view, image, imageData, cacheType, imageURL);
            }
        } completionHandler:^{
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                context.duration = transition.duration;
                context.timingFunction = transition.timingFunction;
                context.allowsImplicitAnimation = (transition.animationOptions & SDWebImageAnimationOptionAllowsImplicitAnimation);
                if (finalSetImageBlock && !transition.avoidAutoSetImage) {
                    finalSetImageBlock(image, imageData);
                }
                if (transition.animations) {
                    transition.animations(view, image);
                }
            } completionHandler:^{
                if (transition.completion) {
                    transition.completion(YES);
                }
            }];
        }];
#endif
    } else {
        if (finalSetImageBlock) {
            finalSetImageBlock(image, imageData);
        }
    }
}
#endif

- (void)sd_setNeedsLayout {
#if SD_UIKIT
    [self setNeedsLayout];
#elif SD_MAC
    [self setNeedsLayout:YES];
#elif SD_WATCH
    // Do nothing because WatchKit automatically layout the view after property change
#endif
}

#if SD_UIKIT || SD_MAC

#pragma mark - Image Transition
- (SDWebImageTransition *)sd_imageTransition {
    return objc_getAssociatedObject(self, @selector(sd_imageTransition));
}

- (void)setSd_imageTransition:(SDWebImageTransition *)sd_imageTransition {
    objc_setAssociatedObject(self, @selector(sd_imageTransition), sd_imageTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#if SD_UIKIT

#pragma mark - Activity indicator
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)sd_setShowActivityIndicatorView:(BOOL)show {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, @(show), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)sd_showActivityIndicatorView {
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)sd_setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)sd_getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

//loading动画
- (void)sd_addActivityIndicator {
    dispatch_main_async_safe(^{
        if (!self.activityIndicator) {
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self sd_getIndicatorStyle]];
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        }
        [self.activityIndicator startAnimating];
    });
}

- (void)sd_removeActivityIndicator {
    dispatch_main_async_safe(^{
        if (self.activityIndicator) {
            [self.activityIndicator removeFromSuperview];
            self.activityIndicator = nil;
        }
    });
}

#endif

#endif

@end
