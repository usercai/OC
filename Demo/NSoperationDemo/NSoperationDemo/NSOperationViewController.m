//
//  NSOperationViewController.m
//  NSoperationDemo
//
//  Created by mac on 2018/8/13.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "NSOperationViewController.h"
#import "HCOperation.h"
@interface NSOperationViewController ()

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //子类1:invocationOperation
//    [self invocationOperation];
    // Do any additional setup after loading the view.
    //子类2
//    [self useBlockOperation];
    //自定义Operation
//    [self usehcOperation];
    //队列
    [self addOperationWithBlockToQueue];
}
//子类一
- (void)invocationOperation{
    // NSInvocationOperation 单独使用时,在当前线程执行
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [op start];

}

-(void)task1{
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2];//模拟耗时操作
        NSLog(@"1------%@",[NSThread currentThread]);
    }
}

-(void)useBlockOperation{
    
    //blockOperationWithBlock 可能在当前线程也可能在其他线程操作
    //
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1----%@",[NSThread currentThread]);
        }
    }];
    // 2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"6---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    [op start];
}

-(void)usehcOperation{
    //可以看出：在没有使用 NSOperationQueue、在主线程单独使用自定义继承自 NSOperation 的子类的情况下，是在主线程执行操作，并没有开启新线程。
    HCOperation * op = [[HCOperation alloc] init];
    [op start];
}
/*
 //主队列
 NSOperationQueue *queue = [NSOperationQueue mainQueue];
 //自定义队列
 
 添加到这种队列中的操作，就会自动放到子线程中执行。
 同时包含了：串行、并发功能。
 NSOperationQueue * que = [[NSOperationQueue alloc] init];
 */
/*
 1. addOperation
 */
-(void)OperationQueue{
    //并发执行
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
    
}

-(void)addOperationWithBlockToQueue{
    //并发执行
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    // 2.使用 addOperationWithBlock: 添加操作到队列中
    //这里不是最大线程数,是一个队列最大的操作数
    queue.maxConcurrentOperationCount = 6;
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 6; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    

}




@end
