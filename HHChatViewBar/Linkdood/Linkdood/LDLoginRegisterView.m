//
//  LDLoginRegisterView.m
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDLoginRegisterView.h"

@implementation LDLoginRegisterView

- (void)nextBtn
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 50)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:RGBACOLOR(0, 185, 237, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-147, 80, 130, 30)];
    label.text = @"点击下一步即表示同意";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGBACOLOR(153, 153, 153, 1);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-17, 80, 170, 30)];
    label1.text =@"《服务条款》、《隐私政策》";
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = RGBACOLOR(0, 149, 192, 1);
    [self addSubview:label];
    [self addSubview:label1];

}
- (void)nextAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(next)]) {
        [self.delegate next];
    }
}

@end
