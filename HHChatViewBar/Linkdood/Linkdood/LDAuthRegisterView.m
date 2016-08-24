//
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDAuthRegisterView.h"

@implementation LDAuthRegisterView

- (void)nextBtn:(BOOL)authRegister
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 42)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    
    [btn.layer setCornerRadius:5];
    [btn setTitle:authRegister == YES?@"下一步":@"找回密码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-147, 70, 130, 30)];
    label.text = @"点击下一步即表示同意";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGBACOLOR(153, 153, 153, 1);
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-17, 70, 170, 30)];
//    label1.text =@"《服务条款》、《隐私政策》";
//    label1.font = [UIFont systemFontOfSize:13];
//    label1.textColor = RGBACOLOR(0, 149, 192, 1);
    [self addSubview:label];
//    [self addSubview:label1];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-17, 70, 95, 30)];
    [btn1 setTitle:@"《服务条款》、" forState:UIControlStateNormal];
    [btn1 setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 addTarget:self action:@selector(serve) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+70, 70, 80, 30)];
    [btn2 setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [btn2 setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];

    [btn2 addTarget:self action:@selector(privacy) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    [self addSubview:btn2];


}
- (void)nextAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(next)]) {
        [self.delegate next];
    }
}

- (void)serve
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(serveTap)]) {
        [self.delegate serveTap];
    }
}

- (void)privacy
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyTap)]) {
        [self.delegate privacyTap];
    }
}

@end
