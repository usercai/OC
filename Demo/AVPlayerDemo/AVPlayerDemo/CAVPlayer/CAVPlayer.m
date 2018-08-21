//
//  CAVPlayer.m
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "CAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface CAVPlayer()

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）
@property (nonatomic,assign)CGRect frame;
@property (nonatomic,strong)UIView * playView;
@end

@implementation CAVPlayer

- (instancetype)initWithFrame:(CGRect )frame addView:(UIView *)Playview
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.playView = Playview;
    }
    return self;
}

-(void)initPlayer{
    
    self.playerLayer.frame = self.frame;
    [self.playView.layer addSublayer:self.playerLayer];
    
    
    
    //通过KVO来观察status属性的变化，来获得播放之前的错误信息
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)play{
    [self.myPlayer play];
}

-(void)pause{
    [self.myPlayer pause];
}



/**
 播放器

 @return AVPlayer
 */
- (AVPlayer *)myPlayer{
    if (!_myPlayer) {
        _myPlayer = [AVPlayer playerWithPlayerItem:self.item];
    }
    return _myPlayer;
}

/**
 播放单元

 @return AVPlayerItem
 */
- (AVPlayerItem *)item{
    if (!_item) {
        _item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
    }
    return _item;
}

- (NSString *)url{
    if ([_url isEqualToString:@""] || _url == nil || ![_url containsString:@"http"]) {
        [self pause];
    }
    return _url;
}

/**
 播放层layer

 @return AVPlayerLayer
 */
- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    }
    return _playerLayer;
}



@end
