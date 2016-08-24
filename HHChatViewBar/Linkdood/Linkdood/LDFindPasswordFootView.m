//
//  LDFindPasswordFootView.m
//  Linkdood
//
//  Created by renxin-.- on 16/1/5.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "LDFindPasswordFootView.h"

@implementation LDFindPasswordFootView

- (void)footView;

{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
    lab.text = @"你的密码学要设置为至少8位，包含数字和字母。";
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self addSubview:lab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 42)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    [btn.layer setCornerRadius:5];
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)confirm
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(findPassword)]) {
        [self.delegate findPassword];
    }
}
@end
