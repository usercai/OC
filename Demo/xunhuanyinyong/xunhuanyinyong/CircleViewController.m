//
//  CircleViewController.m
//  xunhuanyinyong
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 thc. All rights reserved.
//

#import "CircleViewController.h"
#import "Person.h"
@interface CircleViewController ()
@property (nonatomic,copy)void (^test)(void);
@property (nonatomic,copy)NSString * name;
@property (nonatomic,strong)Person * p;
@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.p = [[Person alloc] init];
    [self.p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    // Do any additional setup after loading the view.
}
/**
 当被监听的对象的属性值发生改变时，观察者会调用该方法
 @param keyPath 监听的属性
 @param object  监听的对象
 @param change  新旧值
 @param context 额外参数
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@发生改变",keyPath);
    NSLog(@"change==%@",change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    self.p.name = @"a";
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
