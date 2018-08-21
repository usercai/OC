//
//  ViewController.m
//  xunhuanyinyong
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "TestViewController.h"
#import "CircleViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CircleViewController * test = [[CircleViewController alloc] init];
    [self presentViewController:test animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
