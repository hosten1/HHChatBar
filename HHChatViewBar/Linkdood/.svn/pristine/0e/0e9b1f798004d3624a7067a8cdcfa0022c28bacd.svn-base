//
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDLoginRegisterDelegate <NSObject>

@optional
- (void)next;
- (void)serveTap;
- (void)privacyTap;
@end
@interface LDAuthRegisterView : UIView

@property (weak,nonatomic) id<LDLoginRegisterDelegate> delegate;

- (void)nextBtn:(BOOL)authRegister;

@end
