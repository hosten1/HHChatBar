//
//  LDRootViewController.m
//  Linkdood
//
//  Created by VRV on 15/12/31.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDRootViewController.h"

@interface LDRootViewController ()

@end

@implementation LDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGBACOLOR(51, 51, 51, 1)}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarBackGround"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"navbarLine"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
