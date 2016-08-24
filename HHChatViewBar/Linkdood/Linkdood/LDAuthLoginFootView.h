//
//  Linkdood
//
//  Created by VRV on 15/12/23.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDAuthLoginFootViewDelegate <NSObject>

@optional
- (void)login;
- (void)forgetPassword;
- (void)changeLoginTap:(BOOL)change;
@end

@interface LDAuthLoginFootView : UIView
@property (weak,nonatomic) id<LDAuthLoginFootViewDelegate> delegate;
@property (strong, nonatomic) UIButton *changeEmail;
@property (assign, nonatomic) BOOL emailOrPhone;

- (void)loginBtn:(NSInteger) num;

@end
