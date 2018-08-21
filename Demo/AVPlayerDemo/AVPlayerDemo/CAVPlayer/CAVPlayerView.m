//
//  CAVPlayerView.m
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "CAVPlayerView.h"
@interface CAVPlayerView()
@property (nonatomic,strong)CAVPlayer * player;

@end

@implementation CAVPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.player = [[CAVPlayer alloc] initWithFrame:frame addView:self];
    }
    return self;
}

-(void)startPlayerWithUrl:(NSString *)url{
    self.player.url = url;
    [self.player play];
}







@end
