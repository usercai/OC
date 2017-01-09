//
//  ViewController.m
//  AVPlayerViewControllerDemo
//
//  Created by 诺达 on 17/1/9.
//  Copyright © 2017年 诺达. All rights reserved.
//

#import "ViewController.h"
#import "HCAVPlayerViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (nonatomic,strong)AVPlayerViewController * PlayerVC;
@property (nonatomic,strong)AVPlayerViewController * PlayerVC2;
@property (nonatomic,strong)AVPlayerItem * playerItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(PlayerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    


    // Do any additional setup after loading the view, typically from a nib.
}

-(void)PlayerAction{

    HCAVPlayerViewController * view = [[HCAVPlayerViewController alloc] init];
    [self presentViewController:view animated:YES completion:^{
        //这样就可以进入页面缓冲完便立刻播放
//        [self.PlayerVC2.player play];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"Ready");
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"fail");
        }else{
            NSLog(@"unknow");
        }
    }
}



-(AVPlayerViewController*)PlayerVC{

    if (!_PlayerVC) {
        _PlayerVC = [[AVPlayerViewController alloc] init];
        NSURL * url = [NSURL URLWithString:@"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4"];
        _PlayerVC.player = [AVPlayer playerWithURL:url];
    }
    return _PlayerVC;
}

-(AVPlayerViewController*)PlayerVC2{

    if (!_PlayerVC2) {
        _PlayerVC2 = [[AVPlayerViewController alloc] init];
        NSURL * url = [NSURL URLWithString:@"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4"];
        self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
        _PlayerVC2.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil]; // 观察status属性， 一共有三种属性
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; // 观察缓冲进度
    }
    return _PlayerVC2;
}

@end
