//
//  LoginViewModel.h
//  RAC+MVVM_demo
//
//  Created by 维奕 on 2017/8/22.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface LoginViewModel : NSObject

@property(strong,nonatomic)RACCommand *command;

@property(strong,nonatomic)RACSignal *loginBtnSingle;

@property(strong,nonatomic)NSString *accountStr;

@property(strong,nonatomic)NSString *passwordStr;

@end
