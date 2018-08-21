//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initView{
    // 1. 初始化地址
    NSURL *mediaURL = [NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"];
    // 2. 初始化单元
    self.item = [AVPlayerItem playerItemWithURL:mediaURL];
    // 3. 初始化播放器
    self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
    // 4. 初始化layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, 500);
    [self.view.layer addSublayer:self.playerLayer];
   
    // 5. 播放
    [self.myPlayer play];
    // 播放速度,默认为1
    self.myPlayer.rate = 1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    // 暂停
    [self.myPlayer pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
