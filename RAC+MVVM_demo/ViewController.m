//
//  ViewController.m
//  RAC+MVVM_demo
//
//  Created by 维奕 on 2017/8/21.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"

@interface ViewController ()

@property(strong,nonatomic)LoginViewModel *logoinViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听传值
    RAC(self.logoinViewModel,accountStr)=[self.accountTF rac_textSignal];
    RAC(self.logoinViewModel,passwordStr)=[self.passwordTF rac_textSignal];
    
    //按钮点击是否能点击
    RAC(_loginBtn,enabled) = self.logoinViewModel.loginBtnSingle;
    
    //按钮点击事件
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //执行命令
        [_logoinViewModel.command execute:nil];
        
    }];
    
    
}

//初始化
-(LoginViewModel *)logoinViewModel{
    if (_logoinViewModel==nil) {
        _logoinViewModel=[[LoginViewModel alloc]init];
    }
    return _logoinViewModel;

}


//未分离 MVC
-(void)demo{
    //组合
    
    //按钮点击是否能点击
    RAC(_loginBtn,enabled) = [RACSignal combineLatest:@[_accountTF.rac_textSignal,_passwordTF.rac_textSignal] reduce:^id(NSString *account,NSString *password){
        
        return @(account.length && password.length);
        
    }];
    
        //命令  命令返回信号
        RACCommand *command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
    
            NSLog(@"密码加密");
    
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
                [subscriber sendNext:@"请求登录"];
    
                [subscriber sendCompleted];//发送完成
    
                return nil;
            }];
    
        }];
    
        //命令执行的过程
    //   skip 一次一个
        [[command.executing skip:1] subscribeNext:^(id x) {
            if ([x boolValue]) {
                NSLog(@"显示等待");
            }else{
                NSLog(@"移除等待");
            }
        }];
    
    
        //switchToLatest 最新信号
        [command.executionSignals.switchToLatest subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];//执行信号
    
    
    //按钮点击事件
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //      NSLog(@"点击事件");
        //执行命令
        [command execute:nil];
        
    }];
    
    
  
    


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
