//
//  LDLoginFootView.h
//  Linkdood
//
//  Created by VRV on 15/12/23.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDLoginFooterDelegate <NSObject>

@optional
- (void)login;
- (void)forgetPassword;
@end

@interface LDLoginFootView : UIView
@property (weak,nonatomic) id<LDLoginFooterDelegate> delegate;

- (void)loginBtn;

@end
