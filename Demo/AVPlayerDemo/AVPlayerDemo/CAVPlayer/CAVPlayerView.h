//
//  CAVPlayerView.h
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CAVPlayer.h"
#import "CAVDefine.h"
@interface CAVPlayerView : UIView
@property (strong, nonatomic)UISlider *avSlider;//用来现实视频的播放进度，并且通过它来控制视频的快进快退。
@property (nonatomic,strong)NSString *url;



/**
 初始化

 @param frame
 @return 
 */
- (instancetype)initWithFrame:(CGRect)frame;

-(void)play;

@end
