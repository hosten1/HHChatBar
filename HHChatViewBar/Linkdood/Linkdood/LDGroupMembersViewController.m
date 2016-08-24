//
//  LDGroupMembersViewController.m
//  Linkdood
//
//  Created by VRV on 15/12/11.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDGroupMembersViewController.h"
#import "LDContactListCell.h"
#import "LDInformationViewController.h"
#import "LDContactInfoViewController.h"


@interface LDGroupMembersViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) BOOL cellTap;
@property (nonatomic, strong) LDGroupMemberListModel *memberList;
@end

@implementation LDGroupMembersViewController

-(void)loadView
{
    [super loadView];
    self.memberList = [LDClient sharedInstance].groupMembers;
    [self addObserver:self forKeyPath:@"memberList" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"群成员"];
    [self.groupMemberTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    self.groupMemberTable.sectionIndexBackgroundColor = [UIColor clearColor];
    self.groupMemberTable.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.groupMemberTable.sectionIndexColor = RGBACOLOR(144, 144, 144, 1);
    [self itemButton];
    
    if ([self.memberList numberOfSections] == 0) {
        [self.memberList assembleData];
    }
    [self loadIndexView];
}

- (void)itemButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(chooseDone)];
    self.navigationItem.rightBarButtonItem = item;
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [[LDNotify sharedInstance] groupMembersMoniter:^(LDGroupMemberListModel *groupMembers) {
//        self.memberList = groupMembers;
//    }];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"memberList"];
}

- (void)cancelToChoose
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseDone
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    LDCreateGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDCreateGroupViewController"];
    vc.isAddGroupMember = YES;
    vc.groupID = self.groupModel.ID;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    vc.delegate = self;
}

- (void)showMemberOpreate:(UILongPressGestureRecognizer *)longPress{
    
    if(longPress.state == UIGestureRecognizerStateCancelled){
        return;
    }
    UITableViewCell *cell = (UITableViewCell*)longPress.view;
    NSIndexPath *indexPath = [self.groupMemberTable indexPathForCell:cell];
    LDGroupMemberModel *member = (LDGroupMemberModel *)[_memberList itemAtIndexPath:indexPath];
    UIActionSheet * actionSheet =  [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (member.ID == [LDClient sharedInstance].mySelfInfo.ID) {
        [actionSheet addButtonWithTitle:@"修改群名片"];
    }
    
    LDGroupMemberModel *selfMember = (LDGroupMemberModel*)[_memberList itemWithID:[LDClient sharedInstance].mySelfInfo.ID];
    
    switch (selfMember.userType) {
        case 1:
            break;
        case 2:
            if (member.userType == 1) {
                [actionSheet addButtonWithTitle:@"修改群名片"];
                [actionSheet addButtonWithTitle:NSLocalizedString(@"移出本群", @"")];
            }
            break;
        case 3:
            if (member.ID != [LDClient sharedInstance].mySelfInfo.ID) {
                [actionSheet addButtonWithTitle:@"修改群名片"];
                [actionSheet addButtonWithTitle:member.userType== 1?@"设为管理员":@"取消管理员"];
                [actionSheet addButtonWithTitle:@"移出本群"];
            }
            break;
    }
    
    if (actionSheet.numberOfButtons > 1) {
        [actionSheet showInView:self.view];
    }
    objc_setAssociatedObject(actionSheet, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.groupMemberTable reloadData];
        [self.indexView refreshIndexItems];
    });
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str;
    NSIndexPath *indexPath = objc_getAssociatedObject(actionSheet, "indexPath");
    LDGroupMemberModel *member = (LDGroupMemberModel *)[_memberList itemAtIndexPath:indexPath];
    if (actionSheet.numberOfButtons == 0) {
        return;
    }
    for (int i = 0; i < actionSheet.numberOfButtons; i++) {
        str = [actionSheet buttonTitleAtIndex:i];
        if (buttonIndex == i) {
            if ([str isEqualToString:@"修改群名片"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改群名片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                UITextField *nameField = [alert textFieldAtIndex:0];
                nameField.text = member.name;
                [alert show];
                objc_setAssociatedObject(alert, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            else if ([str isEqualToString:@"移出本群"]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定将 %@ 从本群移出吗?",member.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                objc_setAssociatedObject(alert, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            else if ([str isEqualToString:@"设为管理员"] || [str isEqualToString:@"取消管理员"]){
                if (_groupModel.createrID == [LDClient sharedInstance].mySelfInfo.ID){
                    LDGroupMemberModel *groupMember = [[LDGroupMemberModel alloc] initWithID:member.ID];
                    groupMember.groupID = self.groupModel.ID;
                    groupMember.userType = (member.userType == 1?2:1);
                    [groupMember setGroupManager:^(NSError *error) {
                        
                    }];
                }
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    NSIndexPath *indexPath = objc_getAssociatedObject(alertView, "indexPath");
    LDGroupMemberModel *member = (LDGroupMemberModel *)[_memberList itemAtIndexPath:indexPath];
    
    if ([alertView.title isEqualToString:@"提示"]){
        [[LDClient sharedInstance].groupMembers removeMember:member completion:^(NSError *error) {
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"移除成功" maskType:SVProgressHUDMaskTypeBlack];
                }else{
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                }
        }];
    }else{
        UITextField *nameField = [alertView textFieldAtIndex:0];
        LDGroupMemberModel *groupMember = [[LDGroupMemberModel alloc] initWithID:member.ID];
        groupMember.groupID = self.groupModel.ID;
        groupMember.cardName = nameField.text;
        [groupMember setMemberCardName:^(NSError *error) {
            if (!error) {
                
            }
        }];
    }
}

#pragma mark - LDCreateGroupViewControllerDelegate
-(void)addMemberSuccess{
//直接跳到群聊页面
//    for (UIViewController *vc in self.navigationController.childViewControllers){
//        if ([[NSString stringWithUTF8String:object_getClassName(vc)]isEqualToString:@"LDGroupChatViewController"]) {
//            [self.navigationController popToViewController:vc animated:YES];
//        }
//    }
    [SVProgressHUD showSuccessWithStatus:@"添加成功" maskType:SVProgressHUDMaskTypeBlack];
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
    return [_memberList numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_memberList numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [APP_WINDOW width], 30)];
    header.backgroundColor = [UIColor clearColor];
    header.textAlignment = NSTextAlignmentLeft;
    header.textColor = [UIColor grayColor];
    [header setFont:[UIFont systemFontOfSize:14]];
    
    NSString *title = [_memberList sectionIndexTitle:section];
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
    LDGroupMemberModel *member = (LDGroupMemberModel *)[_memberList itemAtIndexPath:indexPath];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showMemberOpreate:)];
    [cell addGestureRecognizer:longPress];
    [cell updateGroupContact:member Value:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDGroupMemberModel *member = (LDGroupMemberModel *)[_memberList itemAtIndexPath:indexPath];
    
    if([LDClient sharedInstance].mySelfInfo.ID == member.ID){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"myself" bundle:nil];
        LDInformationViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDInformationViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
//        LDContactInfoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDContactInfoViewController"];
//        vc.contactModel = (LDUserModel *)[_memberList itemAtIndexPath:indexPath];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return [_memberList sectionIndexTitles];
}
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.groupMemberTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

@end
