//
//  HCAVPlayerViewController.m
//  AVPlayerViewControllerDemo
//
//  Created by 诺达 on 17/1/9.
//  Copyright © 2017年 诺达. All rights reserved.
//

#import "HCAVPlayerViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RotationScreen.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HCAVPlayerViewController ()
@property (nonatomic,strong)AVPlayerViewController * PlayerVC;
@property (nonatomic,strong)UIView * Playerview;

@end

@implementation HCAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

    // Do any additional setup after loading the view.
}

-(void)initView{

    [self.Playerview addSubview:self.PlayerVC.view];
    [self.PlayerVC.player play];
    //我们可以将它自带的控件隐藏,设置自己需要的样式,我们写一个例子
    //值得注意的是contentOverlayView的大小跟AVPlayerViewController的大小是相同的
    /**
     
     UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 50, 400 - 60, 40, 40)];
     [button setBackgroundImage:[UIImage imageNamed:@"Rotation@2x.png"] forState:UIControlStateNormal];
     [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
     button.backgroundColor = [UIColor whiteColor];
     [self.PlayerVC.contentOverlayView addSubview:button];
     self.PlayerVC.contentOverlayView.userInteractionEnabled = YES;

     */
    
    //但是如果需要高度自定制,笔者建议使用AVPlayer重新进行封装
}

-(void)buttonClick{

    if ([RotationScreen isOrientationLandscape]) { // 如果是横屏，
        [RotationScreen forceOrientation:(UIInterfaceOrientationPortrait)]; // 切换为竖屏
    } else {
        [RotationScreen forceOrientation:(UIInterfaceOrientationLandscapeRight)]; // 否则，切换为横屏
    }
}

-(AVPlayerViewController*)PlayerVC{
    
    if (!_PlayerVC) {
        _PlayerVC = [[AVPlayerViewController alloc] init];
        NSURL * url = [NSURL URLWithString:@"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4"];
        _PlayerVC.player = [AVPlayer playerWithURL:url];
        _PlayerVC.view.frame = CGRectMake(0, 0, WIDTH, 400);
        _PlayerVC.showsPlaybackControls = YES;
    }
    return _PlayerVC;
}

-(UIView*)Playerview{

    if (!_Playerview) {
        _Playerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 400)];
        _Playerview.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_Playerview];
    }
    return _Playerview;
}
@end
