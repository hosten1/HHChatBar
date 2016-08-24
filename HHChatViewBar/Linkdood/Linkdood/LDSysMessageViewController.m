//
//  LDSysMessageViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/4/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDSysMessageViewController.h"
#import "LDSysMessageCell.h"

@interface LDSysMessageViewController ()<SysMessageDelegate>

@property (strong,nonatomic) LDSysMsgListModel *sysMessages;

@end

@implementation LDSysMessageViewController

- (void)awakeFromNib{
    [self setHidesBottomBarWhenPushed:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sysMessages = [[LDSysMsgListModel alloc]init];
    [_sysMessages sysMessages:READTYPE_ALL
                   offsetFlag:0
                      beginID:0
                    msgOffset:10
                   completion:^(NSError *error, LDSysMsgListModel *messages) {
                       [self.tableView reloadData];
    }];
}

- (void)agreePressed:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    LDSysMsgModel *sysModel = (LDSysMsgModel*)[_sysMessages itemAtIndexPath:indexPath];
    
    if(sysModel.msgType == 1){
        [sysModel verifyBuddy:OPER_BUDDY_AGREE refuseReason:nil remark:nil completion:^(NSError *error) {
            if(!error){
                
            }
        }];
    }else if (sysModel.msgType == 3){
        [sysModel verifyGroup:OPER_GROUP_AGREE refuseReason:nil completion:^(NSError *error) {
            if(!error){
                
            }
        }];
    }
}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return [_sysMessages numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sysMessages numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDSysMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDSysMessageDetail"];
    cell.delegate = self;
    [cell setSysMessage:(LDSysMsgModel*)[_sysMessages itemAtIndexPath:indexPath]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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
