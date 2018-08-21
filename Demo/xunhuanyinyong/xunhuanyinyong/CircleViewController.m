//
//  CircleViewController.m
//  xunhuanyinyong
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "CircleViewController.h"

@interface CircleViewController ()
@property (nonatomic,copy)void (^test)(void);
@property (nonatomic,copy)NSString * name;
@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block NSString *value = @"1";
    NSLog(@"aStr指针内存地址：%x",&value);
    void(^test1)(void) = ^(){
        value = @"2";
        NSLog(@"aStr指针内存地址：%x",&value);

    };
    
    test1();
    NSLog(@"aStr指针内存地址：%x",&value);
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
