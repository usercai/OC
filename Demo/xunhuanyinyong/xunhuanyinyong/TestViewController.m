//
//  TestViewController.m
//  xunhuanyinyong
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "TestViewController.h"
#import "Person.h"
#define TLog(prefix,Obj) {NSLog(@"变量内存地址：%p, 变量值：%p, 指向对象值：%@, --> %@",&Obj,Obj,Obj,prefix);}

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self test1];
    // Do any additional setup after loading the view.
}

-(void)test1{
    
    Person *obj = [[Person alloc]init];
    obj.name = @"my-object";
    TLog(@"obj", obj);
    
    __weak Person *weakObj = obj;
    TLog(@"weakObj", weakObj);
    
    void(^testBlock)(void) = ^(){
        TLog(@"weakObj - block", weakObj);
    };
    testBlock();
    obj = nil;
    testBlock();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    NSLog(@"-------------------------");
}

@end
