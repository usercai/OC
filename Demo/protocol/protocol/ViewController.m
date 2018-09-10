//
//  ViewController.m
//  protocol
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,weak)id <testprotocol> delegate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(test)]) {
        [self.delegate test];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
