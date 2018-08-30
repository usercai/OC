//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "ViewController.h"
#import "CAVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）


@property (nonatomic,strong)CAVPlayerView * player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initView{
    
    self.player = [[CAVPlayerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/3)];
    self.player.url = @"http://vjs.zencdn.net/v/oceans.mp4";
    [self.view addSubview:self.player];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
