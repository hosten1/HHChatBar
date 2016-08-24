//
//  LDNewsNoticeTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/3.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDNewsNoticeTableViewController.h"

@interface LDNewsNoticeTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;
@property (weak, nonatomic) IBOutlet UILabel *VsignLab;
@property (weak, nonatomic) IBOutlet UILabel *remindLab;
@property (weak, nonatomic) IBOutlet UISwitch *msgNotice;
@property (weak, nonatomic) IBOutlet UISwitch *disturbed;

@end

@implementation LDNewsNoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新消息通知";

    [self initView];
}

- (void)initView{
    NSNumber *notice = [[LDClient sharedInstance].mySelfInfo myselfConfigure:config_notice];
    NSNumber *Vsign = [[LDClient sharedInstance].mySelfInfo myselfConfigure:config_vsign];
    NSNumber *remind = [[LDClient sharedInstance].mySelfInfo myselfConfigure:config_remind];
    switch ([notice intValue]) {
        case 1:
            _noticeLab.text = @"显示详情";
            break;
        case 2:
            _noticeLab.text = @"只显示发送者消息";
            break;
        case 3:
            _noticeLab.text = @"隐藏详情";
            break;
        default:
            break;
    }
    switch ([Vsign intValue]) {
        case 1:
            _VsignLab.text = @"始终通知加声音震动";
            break;
        case 2:
            _VsignLab.text = @"始终通知";
            break;
        case 3:
            _VsignLab.text = @"按普通联系人／群处理";
            break;
        default:
            break;
    }
    switch ([remind intValue]) {
        case 1:
            _remindLab.text = @"始终通知加声音震动";
            break;
        case 2:
            _remindLab.text = @"始终通知";
            break;
        case 3:
            _remindLab.text = @"按普通联系人／群处理";
            break;
        default:
            break;
    }
    _msgNotice.on = [[LDClient sharedInstance].mySelfInfo myselfSetting:setting_newMessage];
    _disturbed.on = [[LDClient sharedInstance].mySelfInfo noDisturbMode];
}

- (IBAction)changebar:(UISwitch*)sender{
    if (sender.tag == 1000) {
        [[LDClient sharedInstance].mySelfInfo modifyMyselfSetting:setting_newMessage completion:^(NSError *error) {
            if (error == nil) {
                [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
            }else{
                [sender setOn:!sender.isOn];
                [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }else{
        [[LDClient sharedInstance].mySelfInfo changeNodisturbModel:^(NSError *error) {
            if (error == nil) {
                [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
            }else{
                [sender setOn:!sender.isOn];
                [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"显示详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_notice]:@1};
            [self changeContect:verifyDic stringLab:@"显示详情" changeLab:_noticeLab];
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"只显示发送者消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_notice]:@2};
            [self changeContect:verifyDic stringLab:@"只显示发送者消息" changeLab:_noticeLab];
        }];
        UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"隐藏详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_notice]:@3};
            [self changeContect:verifyDic stringLab:@"隐藏详情" changeLab:_noticeLab];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [alertController addAction:actionThree];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"始终通知加声音震动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_vsign]:@1};
            [self changeContect:verifyDic stringLab:@"始终通知加声音震动" changeLab:_VsignLab];
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"始终通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_vsign]:@2};
            [self changeContect:verifyDic stringLab:@"始终通知" changeLab:_VsignLab];
        }];
        UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"按普通联系人／群处理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_vsign]:@3};
            [self changeContect:verifyDic stringLab:@"按普通联系人／群处理" changeLab:_VsignLab];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [alertController addAction:actionThree];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"始终通知加声音震动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_remind]:@1};
            [self changeContect:verifyDic stringLab:@"始终通知加声音震动" changeLab:_remindLab];
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"始终通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_remind]:@2};
            [self changeContect:verifyDic stringLab:@"始终通知" changeLab:_remindLab];
        }];
        UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"按普通联系人／群处理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *verifyDic = @{[NSNumber numberWithInt:config_remind]:@3};
            [self changeContect:verifyDic stringLab:@"按普通联系人／群处理" changeLab:_remindLab];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [alertController addAction:actionThree];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)changeContect:(NSDictionary *)contectDic stringLab:(NSString *)labStr changeLab:(UILabel *)lab
{
    if (![lab.text isEqualToString:labStr]) {
        [[LDClient sharedInstance].mySelfInfo modifyMyselfConfigure:contectDic callBack:^(NSError *error) {
            if (error == nil) {
                lab.text = labStr;
                [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
