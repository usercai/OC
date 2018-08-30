//
//  CAVPlayer.h
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CAVStatus){
    Play,
    Paused,
    ReadToPlay,
    Fail
};

@interface CAVPlayer : NSObject

@property (nonatomic,copy)NSString * url;
@property (assign, nonatomic)BOOL isReadToPlay;//用来判断当前视频是否准备好播放。
@property (nonatomic,assign)CAVStatus status;


/**
 播放
 */
-(void)play;

/**
 暂停
 */
-(void)pause;

/**
 播放URL

 @param url url
 */
-(void)playUrl:(NSString *)url;

- (instancetype)initWithFrame:(CGRect )frame addView:(UIView *)Playview;
@end
