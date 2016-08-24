//
//  LDLoginFootView.m
//  Linkdood
//
//  Created by VRV on 15/12/23.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDLoginFootView.h"

@implementation LDLoginFootView

- (void)loginBtn
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 50)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:RGBACOLOR(0, 185, 237, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIButton *forgetWord = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, SCREEN_WIDTH-200, 30)];
//    forgetWord.backgroundColor = [UIColor redColor];
//    forgetWord.layer.borderWidth = 1;
//    forgetWord.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
//    [forgetWord.layer setCornerRadius:5];
    [forgetWord setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetWord.titleLabel.font = [UIFont systemFontOfSize:16];
    [forgetWord setTitleColor:RGBACOLOR(0, 185, 237, 1) forState:UIControlStateNormal];
    [forgetWord addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetWord];
}

- (void)loginAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(login)]) {
        [self.delegate login];
    }
}

- (void)forgetAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgetPassword)]) {
        [self.delegate forgetPassword];
    }
}

@end
