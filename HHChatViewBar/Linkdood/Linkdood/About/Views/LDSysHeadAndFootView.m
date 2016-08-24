//
//  LDSysHeadAndFootView.m
//  Linkdood
//
//  Created by renxin-.- on 16/2/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDSysHeadAndFootView.h"
#import "LDEntranceViewController.h"



@implementation LDSysHeadAndFootView

//关于连豆豆
- (void)aboutDoodHeadView
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 30, 60, 60)];
    image.image = [UIImage imageNamed:@"AboutIcon"];
    image.layer.cornerRadius = 6;
    image.layer.masksToBounds = YES;
    UILabel *versionNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 20)];
    versionNum.text = [NSString stringWithFormat:@"Linkdood %@(build%@)",APP_VERSION,APP_BUILD];
    versionNum.font = [UIFont systemFontOfSize:13];
    versionNum.textAlignment = NSTextAlignmentCenter;
    versionNum.textColor = RGBACOLOR(144, 144, 144, 1);
    [self addSubview:image];
    [self addSubview:versionNum];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
    [tap setNumberOfTapsRequired:5];
    [image addGestureRecognizer:tap];
    image.userInteractionEnabled = YES;

}

- (void)iconTap:(UITapGestureRecognizer *)recognizer{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Entrance" bundle:nil];
    LDEntranceViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDEntranceViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:nav animated:NO completion:nil];
}


- (void)aboutDoodfootView
{
    UILabel *foot = [[UILabel alloc] initWithFrame:CGRectMake(30, self.frame.size.height-10, SCREEN_WIDTH-60, 15)];
    foot.text = @"©1996-2016 北京北信源软件股份有限公司";
    foot.font = [UIFont systemFontOfSize:13];
    foot.textAlignment = NSTextAlignmentCenter;
    foot.textColor = RGBACOLOR(144, 144, 144, 1);
    [self addSubview:foot];
}

//绑定手机号
- (void)bindPhoneFoot
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15,22, SCREEN_WIDTH-30, 42)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"绑定" forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(bindPhoneTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)bindPhoneTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindPhone)]) {
        [self.delegate bindPhone];
    }
}

//绑定邮箱
- (void)bindEmailFoot
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15,22, SCREEN_WIDTH-30, 42)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"绑定" forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(bindEmailTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)bindEmailTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindEmail)]) {
        [self.delegate bindEmail];
    }
}

//退出登录
- (void)quitLoginFoot
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15,22, SCREEN_WIDTH-30, 42)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(207, 46, 57, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(quitLoginTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)quitLoginTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(quitLogin)]) {
        [self.delegate quitLogin];
    }
}

//修改密码
- (void)modifyPasswordFoot
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 30)];
    lab.text = [LDClient sharedInstance].passwordInfo.ruleStr;
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self addSubview:lab];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15,52, SCREEN_WIDTH-30, 42)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(modifyPasswordTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)modifyPasswordTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyPassword)]) {
        [self.delegate modifyPassword];
    }
}

@end
