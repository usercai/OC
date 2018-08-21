//
//  CAVPlayer.h
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CAVPlayer : NSObject

@property (nonatomic,copy)NSString * url;
@property (assign, nonatomic)BOOL isReadToPlay;//用来判断当前视频是否准备好播放。

-(void)play;

-(void)pause;

- (instancetype)initWithFrame:(CGRect )frame addView:(UIView *)Playview;
@end
