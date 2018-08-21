//
//  HCOperation.m
//  NSoperationDemo
//
//  Created by mac on 2018/8/16.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "HCOperation.h"

@implementation HCOperation
//自定义NSOperation
/*
 如果使用子类 NSInvocationOperation、NSBlockOperation 不能满足日常需求，我们可以使用自定义继承自 NSOperation 的子类。可以通过重写 main 或者 start 方法 来定义自己的 NSOperation 对象。重写main方法比较简单，我们不需要管理操作的状态属性  isExecuting 和 isFinished。当 main 执行完返回的时候，这个操作就结束了。
 
 先定义一个继承自 NSOperation 的子类，重写main方法。
 
 */
- (void)main{
    if (!self.isCancelled) {
        for (int i = 0; i < 2 ; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1----%@",[NSThread currentThread]);
        }
    }
}

@end
