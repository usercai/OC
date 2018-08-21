//
//  src.m
//  blockDemo
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 thc. All rights reserved.
//

int main(int argc, char * argv[]) {
    __block int value = 1;
    void (^test)() = ^(){
        value = 2;
    };
    test();
    int value1 = value;
}
