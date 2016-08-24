//
//  LinkdoodButtonFactory.m
//  Linkdood
//
//  Created by VRV on 16/1/4.
//  Copyright © 2016年 VRV. All rights reserved.
//

@implementation NSString(Button)

+(UIButton *)createGoBackButton:(NSString *)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 23, 23);
    return button;
}

@end
