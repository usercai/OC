//
//  ViewController.m
//  LockDemo
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSLock *lock;
@property(nonatomic,assign)NSInteger number;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //要用同一个nslock才有作用
    self.number = 9;
    _lock = [[NSLock alloc] init];
    
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(que, ^{
        [self threadRunLock];
    });
    
    [self threadRunLock1];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)threadRunLock{
    while (true) {
        [_lock lock];
        if (self.number > 0) {
            [NSThread sleepForTimeInterval:0.5];
            self.number--;
            NSLog(@"thread:%@---->%ld",[NSThread currentThread],self.number);
        }
        [_lock unlock];
    }
    
}

-(void)threadRunLock1{
    
    while (true) {
        [_lock lock];
        if (self.number > 0) {
            [NSThread sleepForTimeInterval:0.5];
            self.number--;
            NSLog(@"thread:%@---->%ld",[NSThread currentThread],self.number);
        }
        [_lock unlock];
    }
    
}




@end
