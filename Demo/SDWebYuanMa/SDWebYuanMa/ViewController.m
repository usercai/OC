//
//  ViewController.m
//  SDWebYuanMa
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "ViewController.h"
#import "SDWebImage/WebCache Categories/UIImageView+WebCache.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

typedef NSDictionary<NSString *,id<NSObject>> dicts;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    
    
    NSString * url = @"";
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:nil failure:nil];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
