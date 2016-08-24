//
//  LDLoginRegisterTableViewController.h
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCountryViewController.h"
@class LDAuthRegisterView;

@interface LDAuthRegisterTableViewController : LDRootTableViewController<CountryDelegate>
@property (weak, nonatomic) IBOutlet UITextField *server;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *identifyCode;
@property (weak, nonatomic) IBOutlet UILabel *nationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneHeader;
@property (assign, nonatomic) BOOL authRegister;
@property (weak, nonatomic) IBOutlet UIButton *identifyBtn;

- (IBAction)getIdentifyCode:(UIButton *)sender;

@end
