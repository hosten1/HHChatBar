//
//  LDLoginRegisterView.h
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDLoginRegisterDelegate <NSObject>

@optional
- (void)next;

@end
@interface LDLoginRegisterView : UIView

@property (weak,nonatomic) id<LDLoginRegisterDelegate> delegate;

- (void)nextBtn;

@end
