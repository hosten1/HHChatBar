//
//  AppDelegate.m
//  Linkdood
//
//  Created by xiong qing on 16/1/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "AppDelegate.h"
#import "LDLoginViewController.h"
#import "LDContactInfoViewController.h"
#import "LDInformationViewController.h"

@implementation AppDelegate

#pragma mark -AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.注册应用证书
    NSString *path = [[LDClient sharedInstance] registerApp:[[NSBundle mainBundle] pathForResource:@"vrv" ofType:@"crt"] onCachePath:@"Linkdood"];
    if (path == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的应用注册失败,请咨询技术支持" delegate:nil cancelButtonTitle:@"明白了" otherButtonTitles:@"如何注册证书", nil];
        [alert show];
        return false;
    }
    
    //2.设置样式
    [[UITabBar appearance] setTintColor:RGBACOLOR(20, 153, 227, 1.0)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"goback"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"goback"]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    //3.注册APNS
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil]];
    
    //4.设置程序后台运行最小间隔时间
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //4.加载主界面
    UIStoryboard *authStory = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    LDLoginViewController *vc = [authStory instantiateViewControllerWithIdentifier:@"LDLoginViewController"];
    self.window.rootViewController = vc;
        
    return YES;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[LDContactInfoViewController class]] || [viewController isKindOfClass:[LDInformationViewController class]]) {
        [[[viewController.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
        [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [viewController.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        viewController.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        viewController.navigationController.navigationBar.translucent = YES;
    }else{
        [[[viewController.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        [viewController.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
        [viewController.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.pushToken = [[[NSString stringWithFormat:@"%@",deviceToken] substringWithRange:NSMakeRange(1, 71)] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    self.pushToken = @"88888888 88888888 88888888 88888888 88888888 88888888 88888888 88888888";
}

#pragma mark -private method
- (void)loginSuccess
{
    //登录成功重置主界面
    _main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LDMainViewController"];
    for (UINavigationController *navController in _main.viewControllers) {
        [navController setDelegate:self];
    }
    [self.window setRootViewController:_main];
    
    //监听上下线
    [[LDNotify sharedInstance] kick:^(LDContactModel *contact) {
        if (!contact) {
            [self logOut];
        }else{
            //好友上下线提醒
        }
    }];
    
    //    LDUserModel *user = [[LDUserModel alloc] initWithID:123456];
    //    [user loadUserInfo:^(LDUserModel *userInfo) {
    //
    //    }];
    //
    //    LDUserModel *user1 = [[LDUserModel alloc] initWithID:234567];
    //    [user1 loadUserInfo:^(LDUserModel *userInfo) {
    //
    //    }];
    
    //    LDGroupModel *group = [[LDGroupModel alloc] initWithID:123456];
    //    [group loadGroupInfo:group_info completion:^(LDGroupModel *groupInfo) {
    //
    //    }];
    //
    //    LDGroupModel *group1 = [[LDGroupModel alloc] initWithID:234567];
    //    [group1 loadGroupInfo:group_info completion:^(LDGroupModel *groupInfo) {
    //
    //    }];
    
    //    LDRobotModel *robot = [[LDRobotModel alloc] initWithID:123456];
    //    [robot loadRobotInfo:^(LDRobotModel *robotInfo) {
    //
    //    }];
    //
    //    LDRobotModel *robot1 = [[LDRobotModel alloc] initWithID:234567];
    //    [robot1 loadRobotInfo:^(LDRobotModel *robotInfo) {
    //
    //    }];
}

- (void)logOut
{
    //退出或被迫下线
    LDAuthModel *auth = [LDClient sharedInstance].loginConfig;
    if (auth) {
        UIStoryboard *authStory = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
        LDAutomaticLoginViewController *vc = [authStory instantiateViewControllerWithIdentifier:@"LDAutomaticLoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }else{
        //先加载登录模块
        UIStoryboard *authStory = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
        LDLoginViewController *vc = [authStory instantiateViewControllerWithIdentifier:@"LDLoginViewController"];
        self.window.rootViewController = vc;
    }
}

@end
