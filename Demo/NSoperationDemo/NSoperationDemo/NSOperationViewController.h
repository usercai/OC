//
//  NSOperationViewController.h
//  NSoperationDemo
//
//  Created by mac on 2018/8/13.
//  Copyright © 2018年 thc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOperationViewController : UIViewController
/*
 最大并发操作数：maxConcurrentOperationCount
 maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
 maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
 maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。
 
 注意：这里 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。
 */
@end
