//
//  GCDViewController.m
//  NSoperationDemo
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //1.串行同步
//    [self thread1];
    //2.串行异步
//    [self thread2];
    //3.并行同步步
//    [self thread3];
    //4.并行异步
//    [self thread4];
    //5.全局(并行)同步,全局(并行)异步
//    [self thread5];
    //6.主线程同步(死锁)
//    [self thread6];
    //7主线程异步
//    [self thread7];
    //8.group
//    [self thread8];
//    [self thread9];
//    [self thread10];
    //9.dispatch block
//    [self dispatchBlock1];
//    [self dispatchBlock2];
//    [self dispatchBlock3];
    //10.dispatch after
//    [self dispatchAfter];
//    [self dispatchApply];
//    11.dispatch_barrier_async
//    [self diapatchBarrier];
//    [self DispatchSet];
    [self dispatchSet2];
    
}

-(void)thread1{
//    1. 串行队列同步执行任务
//    同步不具有开辟新线程的能力，不会开辟新的线程去执行任务，会在当前程序的主线程中,但不是主队列,是新建的串行队列执行任务。
//    按照串行的方式去执行任务
    //如果在串行队列中在进行一个同步操作则会造成死锁,跟主线程同步一个道理
    //打印 start end 321
    NSLog(@"start");
    dispatch_queue_t que = dispatch_queue_create("com.que1", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-------%@",[NSThread currentThread]);

    });
    dispatch_sync(que, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    NSLog(@"end");
    
}

-(void)thread2{
    //    1. 串行队列异步步执行任务
    //开启了一个子线程,不在主线程中执行,所以先走start,跟end,睡眠了3秒后的才执行完,但因为是串行所以只开启一个子线程
    //打印 start end 3 2 1
    NSLog(@"start");
    dispatch_queue_t que = dispatch_queue_create("com.que1", DISPATCH_QUEUE_SERIAL);
    dispatch_async(que, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
    dispatch_async(que, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-------%@",[NSThread currentThread]);
        
    });
    dispatch_async(que, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    NSLog(@"end");
    
}

-(void)thread3{
    //    1. 并行队列同步步执行任务
    //以为是同步,所以不开启子线程
    //打印 start 3 2 1 end
    NSLog(@"start");
    dispatch_queue_t que = dispatch_queue_create("com.que1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-------%@",[NSThread currentThread]);
        
    });
    dispatch_sync(que, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    NSLog(@"end");
    
}

-(void)thread4{
    //    1. 并行队列异步步执行任务
    //开启了一个子线程,不在主线程中执行,所以先走start,跟end,睡眠了3秒后的才执行完
    //打印 start end 1 2 3 ,把sleep去掉就无序打印
    //开启三个子线程,无顺序执行,即使把睡眠去掉也是无序执行
    NSLog(@"start");
    dispatch_queue_t que = dispatch_queue_create("com.que1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(que, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
    dispatch_async(que, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-------%@",[NSThread currentThread]);
        
    });
    dispatch_async(que, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    NSLog(@"end");
    
}

-(void)thread5{

    //因为全局队列是并发队列,但是调试的时候无法获取那个队列,所以结果就是并发同步的结果
    NSLog(@"start");
    dispatch_queue_t que = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-------%@",[NSThread currentThread]);
        
    });
    dispatch_sync(que, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}

-(void)thread6{
    //造成死锁,原因是相互等待
    NSLog(@"start");
    //主队列
    dispatch_queue_t que = dispatch_get_main_queue();
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
    dispatch_sync(que, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-------%@",[NSThread currentThread]);
        
    });
    dispatch_sync(que, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}

-(void)thread7{
    //不会开启新线程,因为主队列已经存在于主线程,不需要重新开启线程
    NSLog(@"start");
    //主队列在主线程中进行
    //打印start end 321
    dispatch_queue_t que = dispatch_get_main_queue();
    dispatch_async(que, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
    dispatch_async(que, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-------%@",[NSThread currentThread]);
        
    });
    dispatch_async(que, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}

-(void)thread8{
    NSLog(@"start");
    dispatch_group_t group=dispatch_group_create();
    dispatch_queue_t queue=dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group_work_1");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"group_work_2");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group_work_3");
    });
//    dispatch_group_notify
//    是通过异步的方式通知，所以，不会阻塞线程
    dispatch_group_notify(group, queue, ^{
        NSLog(@"dispatch_group_Notify 结束");
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"结束之后执行");
        });
    });

}

-(void)thread9{
    NSLog(@"start");
    dispatch_group_t group=dispatch_group_create();
    dispatch_queue_t queue=dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group_work_1");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"group_work_2");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group_work_3");
    });
    
    //在此设置了一个12秒的等待时间，如果group的执行结束没有到12秒那么就返回0
    //如果执行group的执行时间超过了12秒，那么返回非0 数值，
    //在使用dispatch_group_wait函数的时候，会阻塞当前线程，阻塞的时间 在wait函数时间值和当前group执行时间值取最小的。
    long kk=dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC));
    if(kk==0)
    {
        NSLog(@"dispatch_group_wait 结果1");
    }
    else
    {
        NSLog(@"dispatch_group_wait 结果2");
    }
}

-(void)thread10
{
    // 群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 1> 入组 -> 之后的 block 会被 group 监听
    // dispatch_group_enter 一定和 dispatch_group_leave 要配对出现
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"dispatch_async_work1");
        
        // block 的末尾，所有任务执行完毕后，添加一个出组
        dispatch_group_leave(group);
    });
    
    //  再次入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:6];
        
        NSLog(@"dispatch_async_work1");
        
        // block 的末尾，所有任务执行完毕后，添加一个出组
        dispatch_group_leave(group);
    });
    
    // 群组结束
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"OVER");
    });
    NSLog(@"come here");
}

-(void)dispatchBlock1
{
    dispatch_queue_t queue = dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t block=dispatch_block_create(0, ^{
        NSLog(@"dispatchBlock_work");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"before");
    });
    
    dispatch_sync(queue, block);
    //等待前面的任务执行完毕
    long kk=dispatch_block_wait(block, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC));
    if(kk==0)
    {
        NSLog(@"coutinue");
    }
    else
    {
        NSLog(@"timeOut！！！");
    }
    

}
-(void)dispatchBlock2
{
    dispatch_queue_t queue = dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t previousBlock = dispatch_block_create(0, ^{
        NSLog(@"previousBlock begin");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"previousBlock done");
    });
    dispatch_async(queue, previousBlock);
    dispatch_block_t notifyBlock = dispatch_block_create(0, ^{
        NSLog(@"notifyBlock");
    });
    //当previousBlock执行完毕后，提交notifyBlock到global queue中执行
    dispatch_block_notify(previousBlock, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), notifyBlock);
}

-(void)dispatchBlock3
{
    dispatch_queue_t queue = dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        NSLog(@"block1 begin");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"block1 done");
    });
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        NSLog(@"block2 ");
    });
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_block_cancel(block2);
}
-(void)dispatchAfter
{
//    NSEC_PER_SEC表示的是秒数，它还提供了NSEC_PER_MSEC表示毫秒。
    NSLog(@"dispatchAfter_start");
    int64_t time=2*NSEC_PER_SEC;
    
    dispatch_queue_t mainQueue=dispatch_get_main_queue();
    
    for (int i=0; i<5; i++) {
        dispatch_time_t disTime=dispatch_time(DISPATCH_TIME_NOW, time*i);
        
        dispatch_after(disTime, mainQueue, ^{
            NSLog(@"dispatchAfter_work-----%@",[NSThread currentThread]);
        });
    }
    
}

-(void)dispatchApply
{
//    dispatch_apply类似一个for循环，会在指定的dispatch queue中运行block任务n次，如果队列是并发队列，则会并发执行block任务，dispatch_apply是一个同步调用，block任务执行n次后才返回。
    //并发队列,开启6个新线程,串行并列在主线程调用
    dispatch_queue_t queue = dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_apply(6, queue, ^(size_t i) {
        NSLog(@"do a job %zu times---%@",i,[NSThread currentThread]);
        
    });
    
    NSLog(@"go on");
}

/*
 static SingletonTimer * instance;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 instance = [[SingletonTimer alloc] init];
 });
 
 return instance;
 */

/*
 10. dispatch_barrier_async
 dispatch_barrier_async用于等待前面的任务执行完毕后自己才执行，而它后面的任务需等待它完成之后才执行。一个典型的例子就是数据的读写，通常为了防止文件读写导致冲突，我们会创建一个串行的队列，所有的文件操作都是通过这个队列来执行，比如FMDB，这样就可以避免读写冲突。不过其实这样效率是有提升的空间的，当没有更新数据时，读操作其实是可以并行进行的，而写操作需要串行的执行
 */
-(void)diapatchBarrier
{
    dispatch_queue_t queue = dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"dispatch_async_work1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async_work2");
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_async_work3");
        [NSThread sleepForTimeInterval:1];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async_work4");
    });
}

/*
1.系统的Global Queue是可以指定优先级的，那我们可以用到dispatch_set_target_queue这个方法来指定自己创建队列的优先级
 */
-(void)DispatchSet
{
    ///存在疑问 这个优先级问题,Default 比 high还高?
    dispatch_queue_t serialDiapatchQueue=dispatch_queue_create("com.GCD_demo.www", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t dispatchgetglobalqueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //设置比Low还低
    dispatch_set_target_queue(serialDiapatchQueue, dispatchgetglobalqueue);
    dispatch_async(serialDiapatchQueue, ^{
        NSLog(@"我优先级低，先让让----%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"我优先级高,我先block----%@",[NSThread currentThread]);
    });
}

/*
 2.dispatch_set_target_queue除了能用来设置队列的优先级之外，还能够创建队列的层次体系，当我们想让不同队列中的任务同步的执行时，我们可以创建一个串行队列，然后将这些队列的target指向新创建的队列即可
 */
-(void)dispatchSet2
{
    dispatch_queue_t targetQueue = dispatch_queue_create("target_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    
    dispatch_async(queue1, ^{
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"do job1-----%@",[NSThread currentThread]);
        
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"do job2------%@",[NSThread currentThread]);
        
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"do job3------%@",[NSThread currentThread]);
        
    });
}




@end

