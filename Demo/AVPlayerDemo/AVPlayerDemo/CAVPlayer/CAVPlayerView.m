//
//  CAVPlayerView.m
//  AVPlayerDemo
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "CAVPlayerView.h"
#define avHeaderViewHeight 40
@interface CAVPlayerView()
@property (nonatomic,strong)CAVPlayer * player;
@property (nonatomic,strong)UIView * avHeaderView;
@property (nonatomic,strong)UIView * avFooterView;
@property (nonatomic,strong)UIButton * backBtn;
@property (nonatomic,strong)UIButton * playbtn;
@property (nonatomic,strong)UIButton * footerplaybtn;

/**
 默认图
 */
@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,assign)BOOL viewHidden;


@end

@implementation CAVPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.player = [[CAVPlayer alloc] initWithFrame:frame addView:self];
        self.backgroundColor = [UIColor blackColor];

        [self initView];

    }
    return self;
}

-(void)initView{
    
    CGFloat centerx = self.frame.size.width/2;
    CGFloat centery = self.frame.size.height/2;
    
    self.bgImage = [[UIImageView alloc] initWithFrame:self.frame];
    self.bgImage.image = [UIImage imageNamed:@""];
    [self addSubview:self.bgImage];
    
    self.avHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopState, self.frame.size.width, 40)];
    self.backBtn.frame = CGRectMake(20, 0, 40, avHeaderViewHeight);
    self.backBtn.backgroundColor = [UIColor redColor];
    [self.avHeaderView addSubview:self.backBtn];
    self.avHeaderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self addSubview:self.avHeaderView];

    
    self.playbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.playbtn.center = CGPointMake(centerx, centery);
    self.playbtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.playbtn setImage:[UIImage imageNamed:@"avplayer_play"] forState:UIControlStateNormal];
    self.playbtn.layer.cornerRadius = 30;
    [self.playbtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playbtn];
    
    self.avFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
    [self addSubview:self.avFooterView];
    self.footerplaybtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.footerplaybtn setImage:[UIImage imageNamed:@"smallplay"] forState:UIControlStateNormal];
    [self.footerplaybtn setImage:[UIImage imageNamed:@"smallpause"] forState:UIControlStateSelected];
    self.footerplaybtn.selected = NO;
    [self.avFooterView addSubview:self.footerplaybtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    
    self.viewHidden = YES;
    [self.playbtn setHidden:NO];
}

-(void)playClick{

    self.footerplaybtn.selected = !self.footerplaybtn.selected;
    [self.bgImage setHidden:YES];
    [self.player play];
    
}
//点击手势
-(void)tapClick{
    
    self.viewHidden = !self.viewHidden;
}



- (void)setViewHidden:(BOOL)viewHidden{
    
    _viewHidden = viewHidden;
    [self.avHeaderView setHidden:viewHidden];
    [self.avFooterView setHidden:viewHidden];
    [self.playbtn setHidden:viewHidden];
}

- (void)setUrl:(NSString *)url{
    _url = url;
    [self.player playUrl:url];
}

-(void)play{
    [self.player play];
}






@end
