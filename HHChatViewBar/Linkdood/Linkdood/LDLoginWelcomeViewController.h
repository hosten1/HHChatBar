//
//  LDLoginWelcomeViewController.h
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDLoginWelcomeViewController : LDRootViewController
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)loginTap:(UIButton *)sender;
- (IBAction)registerTap:(UIButton *)sender;

@end
