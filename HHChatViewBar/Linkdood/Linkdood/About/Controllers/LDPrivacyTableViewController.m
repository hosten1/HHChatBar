//
//  LDPrivacyTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/4/27.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDPrivacyTableViewController.h"
@interface LDPrivacyTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *doodSwitchBar;
@property (weak, nonatomic) IBOutlet UISwitch *phoneSwitchBar;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwtichBar;
@property (weak, nonatomic) IBOutlet UISwitch *shareSwitchBar;
@property (weak, nonatomic) IBOutlet UILabel *verifyLab;

@end
@implementation LDPrivacyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"私聊";
    [_doodSwitchBar addTarget:self action:@selector(searchDood:) forControlEvents:UIControlEventValueChanged];
    [_phoneSwitchBar addTarget:self action:@selector(searchPhone:) forControlEvents:UIControlEventValueChanged];
    [_emailSwtichBar addTarget:self action:@selector(searchEmail:) forControlEvents:UIControlEventValueChanged];
    [_shareSwitchBar addTarget:self action:@selector(shareRemind:) forControlEvents:UIControlEventValueChanged];
    [self initView];
}

- (void)initView{
    NSNumber *verify = [[LDClient sharedInstance].mySelfInfo myselfConfigure:config_verify];
    switch ([verify intValue]) {
        case 1:
            _verifyLab.text = @"需要验证信息";
            break;
        case 2:
            _verifyLab.text = @"不允许任何人添加";
            break;
        case 3:
            _verifyLab.text = @"允许任何人添加";
            break;
        default:
            break;
    }
    _doodSwitchBar.on = [[LDClient sharedInstance].mySelfInfo myselfSetting:setting_checkDood];
    _phoneSwitchBar.on = [[LDClient sharedInstance].mySelfInfo myselfSetting:setting_checkPhone];
    _emailSwtichBar.on = [[LDClient sharedInstance].mySelfInfo myselfSetting:setting_checkEmail];
    _shareSwitchBar.on = [[LDClient sharedInstance].mySelfInfo myselfSetting:setting_share];
}

- (void)searchDood:(id)sender{
    [[LDClient sharedInstance].mySelfInfo modifyMyselfSetting:setting_checkDood completion:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            [(UISwitch*)sender setOn:[(UISwitch*)sender isOn]];
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
- (void)searchPhone:(id)sender{
    [[LDClient sharedInstance].mySelfInfo modifyMyselfSetting:setting_checkPhone completion:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            [(UISwitch*)sender setOn:[(UISwitch*)sender isOn]];
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
- (void)searchEmail:(id)sender{
    [[LDClient sharedInstance].mySelfInfo modifyMyselfSetting:setting_checkEmail completion:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            [(UISwitch*)sender setOn:[(UISwitch*)sender isOn]];
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
- (void)shareRemind:(id)sender{
    [[LDClient sharedInstance].mySelfInfo modifyMyselfSetting:setting_share completion:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            [(UISwitch*)sender setOn:[(UISwitch*)sender isOn]];
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] initWithFrame:(CGRect){0,0,[APP_WINDOW width],30}];
    [header setBackgroundColor:[UIColor clearColor]];
    [header setTextColor:[UIColor grayColor]];
    [header setFont:[UIFont systemFontOfSize:14]];
    if (section == 0) {
        [header setText: @"  通讯录"];
    }
    if (section == 1) {
        [header setText: @"  好友添加限制"];
    }
    if (section == 2){
        [header setText:@"  分享"];
    }
    
    return  header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"需要验证信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_verify]:@1};
            [self changeContect:verifyDic stringLab:@"需要验证的信息"];
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"不允许任何人添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_verify]:@2};
            [self changeContect:verifyDic stringLab:@"不允许任何人添加"];
        }];
        UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"允许任何人添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_verify]:@3};
            [self changeContect:verifyDic stringLab:@"允许任何人添加"];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [alertController addAction:actionThree];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)changeContect:(NSDictionary *)contectDic stringLab:(NSString *)labStr
{
    if (![_verifyLab.text isEqualToString:labStr]) {
        [[LDClient sharedInstance].mySelfInfo modifyMyselfConfigure:contectDic callBack:^(NSError *error) {
            if (error == nil) {
                _verifyLab.text = labStr;
                [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}

@end
