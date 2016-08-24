//
//  LDGroupAtChooseViewController.m
//  Linkdood
//
//  Created by yue on 16/6/20.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDGroupAtChooseViewController.h"
#import "LDContactListCell.h"
#import "LinkdoodButtonFactory.h"

@interface LDGroupAtChooseViewController()
{
    LDGroupMemberListModel *members;
}

@end

@implementation LDGroupAtChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.groupMemberTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    self.groupMemberTable.sectionIndexBackgroundColor = [UIColor clearColor];
    self.groupMemberTable.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.groupMemberTable.sectionIndexColor = RGBACOLOR(144, 144, 144, 1);
    [self loadIndexView];
    self.title = @"@群成员";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"所有人" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllMember)];
    UIButton *button = [NSString createGoBackButton:@"goback"];
    
    [button addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    members = [LDClient sharedInstance].groupMembers;
    if ([members numberOfSections] == 0) {
        [members assembleData];
    }
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

- (void)selectAllMember{
    if(self.memberChoosen){
        self.memberChoosen(_groupModel.ID);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dissmiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    return [members numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [members numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [APP_WINDOW width], 30)];
    header.backgroundColor = [UIColor clearColor];
    header.textAlignment = NSTextAlignmentLeft;
    header.textColor = [UIColor grayColor];
    [header setFont:[UIFont systemFontOfSize:14]];

    NSString *title = [members sectionIndexTitle:section];
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
    LDGroupMemberModel *member = (LDGroupMemberModel *)[members itemAtIndexPath:indexPath];
    [cell updateGroupContact:member Value:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDGroupMemberModel *member = (LDGroupMemberModel *)[members itemAtIndexPath:indexPath];
    
    if([LDClient sharedInstance].mySelfInfo.ID != member.ID){
        if(self.memberChoosen){
            self.memberChoosen(member.ID);
        }
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return [members sectionIndexTitles];
}
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.groupMemberTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

@end
