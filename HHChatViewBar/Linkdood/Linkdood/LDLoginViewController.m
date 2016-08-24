 //
//  LDLoginViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/2/17.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDLoginViewController.h"
#import "LDLoginWelcomeViewController.h"
#import "LDAutomaticLoginViewController.h"
#import "AppDelegate.h"

@interface LDLoginViewController ()

@end

@implementation LDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    typedef void (^LDLoginFailBlock) (void);
    
    LDLoginFailBlock block = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *authStory = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
            LDLoginWelcomeViewController *vc = [authStory instantiateViewControllerWithIdentifier:@"LDLoginWelcomeViewController"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [SYS_DELEGATE.window setRootViewController:nav];
        });
    };
    
    LDAuthModel *authModel = [LDClient sharedInstance].loginConfig;
    if (authModel && authModel.account) {
        if(![authModel.password isEmpty]){
            [[LDClient sharedInstance] autoLogin:^(NSError *error) {
                if (!error) {
                    [(AppDelegate*)SYS_DELEGATE loginSuccess];
                }else{
                    [(AppDelegate*)SYS_DELEGATE logOut];
                }
            }];
        }else{
            [(AppDelegate*)SYS_DELEGATE logOut];
        }
    }else{
        block();
    }
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:imgV];
    
    if (SCREEN_WIDTH == 320) {
        if (SCREEN_HEIGHT == 480) {
            imgV.image = [UIImage imageNamed:@"screen640x960"];
        }
        else{
            imgV.image = [UIImage imageNamed:@"screen640x1136"];
        }
    }
    if (SCREEN_WIDTH == 375) {
        imgV.image = [UIImage imageNamed:@"screen750x1134"];
    }
    if (SCREEN_WIDTH == 414) {
        imgV.image = [UIImage imageNamed:@"screen1242x2208"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogin:(id)sender
{

    
//    [authModel login:[NSString stringWithFormat:@"0086%@",account] Password:password Domain:server completion:^(bool state, NSDictionary *dict) {
//        if (state) {
//            [SVProgressHUD dismiss];
//            [[LDClient sharedInstance] createClient];
//            
//            authModel.account = [NSString stringWithFormat:@"0086%@",account];
//            authModel.ID = [[dict objectForKey:@"userid"] longLongValue];
//            authModel.timestamp = [[dict objectForKey:@"time"] longLongValue];
//            authModel.password = password;
//            authModel.domain = [dict objectForKey:@"area"];
//            
//            LDSysConfigModel *sysConfig = [[LDClient sharedInstance] sysConfig];
//            [sysConfig setAutoLoginConfig:authModel completion:^(bool state) {
//                NSLog(@"设置成功");
//            }];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:_server forKey:@"serverDefault"];
//            [[NSUserDefaults standardUserDefaults] setObject:_account forKey:@"accountDefault"];
//            [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"passwordDefault"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                num = 0;
//                [(AppDelegate*)SYS_DELEGATE fillViews];
//            });
//            
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD showErrorWithStatus:[NSString errorString:[[dict objectForKey:@"code"] intValue]]];
//                if (num>4) {
//                    [_loginTableView reloadData];
//                }
//                num++;
//            });
//        }
//    }];
}

@end
