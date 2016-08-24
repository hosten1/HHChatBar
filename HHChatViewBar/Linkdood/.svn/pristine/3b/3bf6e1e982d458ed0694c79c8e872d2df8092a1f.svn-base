//
//  Linkdood
//
//  Created by VRV on 15/12/23.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDAuthLoginFootView.h"

@implementation LDAuthLoginFootView

- (void)loginBtn:(NSInteger)num
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 42)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIButton *forgetWord = [[UIButton alloc] initWithFrame:CGRectMake(100, 70, SCREEN_WIDTH-200, 30)];
    [forgetWord setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetWord.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetWord setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    [forgetWord addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetWord];
    
    _changeEmail = [[UIButton alloc] initWithFrame:CGRectMake(100, SCREEN_HEIGHT-340, SCREEN_WIDTH-200, 30)];
    
    [_changeEmail setTitle:@"邮箱登陆" forState:UIControlStateNormal];
    _changeEmail.titleLabel.font = [UIFont systemFontOfSize:14];
    [_changeEmail setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    [_changeEmail addTarget:self action:@selector(changeLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_changeEmail];
    _emailOrPhone = YES;
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
- (void)changeLogin
{
    if (_emailOrPhone == YES) {
        [_changeEmail setTitle:@"手机登录" forState:UIControlStateNormal];
        _emailOrPhone = NO;
    }
    else{
        [_changeEmail setTitle:@"邮箱登陆" forState:UIControlStateNormal];
        _emailOrPhone = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeLoginTap:)]) {
        [self.delegate changeLoginTap:_emailOrPhone];
    }
}
@end
