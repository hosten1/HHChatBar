 //
//  LDGeneralTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/3.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDGeneralTableViewController.h"

@interface LDGeneralTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitchBar;
@property (strong,nonatomic)LDNoteListModel *noteList;
@property (strong,nonatomic)LDNoteModel *note;
@property (strong,nonatomic)LDTaskMessageModel *taskList;
@property (strong,nonatomic)LDTaskMessageListModel *list;
@property (strong,nonatomic)NSArray *aryy;
@end

@implementation LDGeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用";
    [_onlineSwitchBar addTarget:self action:@selector(changebar:) forControlEvents:UIControlEventValueChanged];
    [self initView];
    [[LDClient sharedInstance].mySelfInfo myselfConfigure:config_birthday];
    _aryy = [[NSArray alloc] init];
    _note = [[LDNoteModel alloc] init];
    NSLog(@"%lld",MYSELF.ID);
}

- (void)initView{
    _onlineSwitchBar.on = [[LDClient sharedInstance].mySelfInfo myselfSetting:setting_online];
}

- (void)changebar:(id)sender{
    [[LDClient sharedInstance].mySelfInfo modifyMyselfSetting:setting_online completion:^(NSError *error) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"清空聊天记录");
        [[LDClient sharedInstance].chatListModel removeHistoryMessageFor:nil completion:^(NSError *error) {
            
        }];
    }
//    if(indexPath.section == 1 && indexPath.row == 1){
////        4328622552
//        _taskList = [[LDTaskMessageModel alloc] init];
//        _taskList.receTargetID = 4328622552;
//        _taskList.message = @"poiu";
//        
//        [_taskList sendMessageTo:4328622552 onStatus:^(msg_send_status status) {
//            NSLog(@"123");
//        }];
//    }
//    if (indexPath.section == 1 && indexPath.row == 2) {
////        [self performSegueWithIdentifier:@"LDNoteListViewController" sender:nil];
//        _list = [[LDTaskMessageListModel alloc] init];
//        [_list queryReceiveMessages:^(NSError *error) {
//            NSArray *ary = [_list allItems];
//            NSLog(@"%@",ary);
//        }];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
