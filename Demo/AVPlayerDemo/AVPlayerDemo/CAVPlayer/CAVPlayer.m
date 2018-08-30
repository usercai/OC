//
//  CAVPlayer.m
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "CAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "CAVDefine.h"



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
        [self initPlayer];
    }
    return self;
}

-(void)initPlayer{
    
    self.playerLayer.frame = self.frame;
    [self.playView.layer addSublayer:self.playerLayer];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                self.status = Fail;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                self.status = ReadToPlay;
//                self.avSlider.maximumValue = self.item.duration.value / self.item.duration.timescale;
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                self.status = Fail;
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}


-(void)play{
    if (![self.url containsString:@"http"]) {
        CAVLog(@"播放地址错误");
        return;
    }
    if (!self.isReadToPlay) {
        return;
    }
    //播放
    if (self.myPlayer.rate != 0.0) {
        [self.myPlayer pause];
    }else{
        [self.myPlayer play];
    }
}

-(void)pause{
    [self.myPlayer pause];
}

-(void)playUrl:(NSString *)url{

    self.url = url;
}

- (CAVStatus)status{
    if (self.isReadToPlay) {
        _status = ReadToPlay;
        if (self.myPlayer.rate == 0.0) {
            _status = Paused;
        }else if (self.myPlayer.rate > 0.0 ){
            _status = Play;
        }
    }else{
        _status = Fail;
    }
    
    return _status;
}


-(void)relase{
    [self.playerLayer removeFromSuperlayer];
    self.playView = nil;
    self.myPlayer = nil;
    [self.item removeObserver:self forKeyPath:@"status"];
    self.item = nil;
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


/**
 重写set方法
 */
- (void)setUrl:(NSString *)url{
    
//    [self.item removeObserver:self forKeyPath:@"status"];
//    self.item = nil;
    _url = url;
    self.item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myPlayer replaceCurrentItemWithPlayerItem:self.item];
    });
}

/**
 播放层layer

 @return AVPlayerLayer
 */
- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
//        _playerLayer.frame = self.frame;
    }
    return _playerLayer;
}



@end
