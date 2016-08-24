//
//  AppDelegate.h
//  Linkdood
//
//  Created by xiong qing on 16/1/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDMainViewController.h"
#import "LDLoginViewController.h"
#import "LDAutomaticLoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LDMainViewController *main;
@property (strong, nonatomic) NSString *pushToken;

- (void)loginSuccess;
- (void)logOut;

@end

