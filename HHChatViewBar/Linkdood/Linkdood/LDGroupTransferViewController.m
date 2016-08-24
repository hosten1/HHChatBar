//
//  LDGroupTransferViewController.m
//  Linkdood
//
//  Created by 王越 on 16/4/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDGroupTransferViewController.h"
#import "LDContactListCell.h"

@interface LDGroupTransferViewController ()

@end

@implementation LDGroupTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    [groupMembers assembleData];
    [self.groupMemberTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    self.groupMemberTable.sectionIndexBackgroundColor = [UIColor clearColor];
    self.groupMemberTable.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.groupMemberTable.sectionIndexColor = RGBACOLOR(144, 144, 144, 1);
    [self loadIndexView];
    self.title = @"转让群";
}

- (void)loadIndexView
{
    if (!self.indexView) {
        self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
        self.indexView.dataSource = self;
        self.indexView.font = [UIFont systemFontOfSize:13];
        self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        [self.view addSubview:self.indexView];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    return [groupMembers numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    return [groupMembers numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [APP_WINDOW width], 30)];
    header.backgroundColor = [UIColor clearColor];
    header.textAlignment = NSTextAlignmentLeft;
    header.textColor = [UIColor grayColor];
    [header setFont:[UIFont systemFontOfSize:14]];
    
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    NSString *title = [groupMembers sectionIndexTitle:section];
    [header setText:[NSString stringWithFormat:@"    %@",[title isEqualToString:@"#"]?@"管理员":title]];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMeb" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath forTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Cell Configuration
- (void)configureCell:(LDContactListCell *)cell atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView
{
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    LDGroupMemberModel *member = (LDGroupMemberModel *)[groupMembers itemAtIndexPath:indexPath];
    [cell updateGroupContact:member Value:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    LDGroupMemberModel *member = (LDGroupMemberModel *)[groupMembers itemAtIndexPath:indexPath];
    
    if([LDClient sharedInstance].mySelfInfo.ID == member.ID){
        [SVProgressHUD showErrorWithStatus:@"不能转让给自己" maskType:SVProgressHUDMaskTypeBlack];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否转让群给%@?",member.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        objc_setAssociatedObject(alert, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSIndexPath *indexPath = objc_getAssociatedObject(alertView, "indexPath");
        LDGroupMemberModel *member = (LDGroupMemberModel *)[[LDClient sharedInstance].groupMembers itemAtIndexPath:indexPath];
        LDGroupModel *group = [[LDGroupModel alloc] initWithID:_groupModel.ID];
        [group transferGroup:member completion:^(NSError *error) {
                if (!error) {
                    [self.indexView removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD showSuccessWithStatus:@"转让成功" maskType:SVProgressHUDMaskTypeBlack];
                }else{
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                }
        }];
    }
}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    return [groupMembers sectionIndexTitles];
}
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.groupMemberTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}
@end
