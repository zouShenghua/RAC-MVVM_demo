
//
//  LoginViewModel.m
//  RAC+MVVM_demo
//
//  Created by 维奕 on 2017/8/22.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel


-(instancetype)init{
    if (self=[super init]) {
        
        [self test];
        
    }
    return self;

}

-(void)test{
    
    //组合
    //按钮点击是否能点击
    _loginBtnSingle = [RACSignal combineLatest:@[RACObserve(self, accountStr),RACObserve(self, passwordStr)] reduce:^id(NSString *account,NSString *password){
        
        return @(account.length && password.length);
        
    }];
    
    
    self.command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"密码加密");
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求登录"];
            
            [subscriber sendCompleted];//发送完成
            
            return nil;
        }];
        
    }];
    
    //命令执行的过程
    //   skip 一次一个
    [[self.command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"显示等待");
        }else{
            NSLog(@"移除等待");
        }
    }];
    
    
    //switchToLatest 最新信号
    [self.command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];//执行信号


}


@end
