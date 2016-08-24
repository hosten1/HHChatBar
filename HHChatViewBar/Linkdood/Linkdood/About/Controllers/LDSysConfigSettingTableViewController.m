//
//  LDSysConfigSettingTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/2/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDSysConfigSettingTableViewController.h"

@interface LDSysConfigSettingTableViewController ()

@end

@implementation LDSysConfigSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";

}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma marl - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"sysSettingToAccountSecurity" sender:nil];
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"setToMessageNotice" sender:nil];
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"setToPrivacy" sender:nil];
    }
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"sysSettingToGeneral" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
