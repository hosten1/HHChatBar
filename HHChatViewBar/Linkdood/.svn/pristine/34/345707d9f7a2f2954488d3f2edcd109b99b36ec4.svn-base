//
//  LDSysHeadAndFootView.h
//  Linkdood
//
//  Created by renxin-.- on 16/2/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDSysHeadAndFootViewDelegate <NSObject>
@optional
- (void)quitLogin;       //退出登录
- (void)bindPhone;       //绑定手机
- (void)bindEmail;       //绑定邮箱
- (void)modifyPassword;  //更改密码


@end
@interface LDSysHeadAndFootView : UIView
- (void)aboutDoodHeadView;   //关于连豆豆
- (void)aboutDoodfootView;   //关于连豆豆
- (void)bindPhoneFoot;       //绑定手机
- (void)bindEmailFoot;       //绑定邮箱
- (void)quitLoginFoot;       //退出登录
- (void)modifyPasswordFoot;  //更改密码


@property (nonatomic, weak) id <LDSysHeadAndFootViewDelegate> delegate;

@end
