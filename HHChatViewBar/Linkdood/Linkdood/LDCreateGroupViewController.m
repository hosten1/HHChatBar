//
//  IMNew
//
//  Created by VRV on 15/9/17.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import "LDCreateGroupViewController.h"
#import "LDCreatGroupCell.h"
#import "ContactListItem.h"
#import "ContactHorizontalList.h"
#import "LDGroupMembersViewController.h"


@interface LDCreateGroupViewController (){
    LDContactListModel *contactList;
}


@property (nonatomic, retain) NSMutableDictionary *allPeopleDict;

@end

@implementation LDCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contactList = [[LDClient sharedInstance] contactListModel];
    if (contactList.numberOfSections == 0) {
        [contactList assembleData];
    }
    
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    
    if(_isAddGroupMember){
        [contactList setDefaultSelectItems:[contactList compareWithList:groupMembers]];
    }
    self.title = NSLocalizedString(@"选择联系人", nil);


    [self.creatTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    self.creatTable.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.navigationController.navigationBar.translucent = NO;
    
    _creatTable.delegate=self;
    _creatTable.dataSource=self;
    _creatTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBar setTitle:@"取消" forState:UIControlStateNormal];
    [leftBar setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftBar.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [leftBar addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    leftBar.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBar setTitle:@"完成" forState:UIControlStateNormal];
    [rightBar setTitleColor:RGBACOLOR(0, 183, 238, 1) forState:UIControlStateNormal];
    [rightBar.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBar addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
    rightBar.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self.createDataSet  getItems];
//    [contactList assembleData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [contactList clearSelectItems];
}


-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)chooseDone{
    if ([contactList selectedItems].count == 0) {
        return;
    }
    
    if (!_isAddGroupMember) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"创建中...", nil) maskType:SVProgressHUDMaskTypeBlack];
        
        [[LDClient sharedInstance].groupListModel createGroupWithInviteMembers:[contactList selectedItems] completion:^(NSError *error, NSDictionary *info) {
            [SVProgressHUD dismiss];
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate respondsToSelector:@selector(createGroupSuccess:)]) {
                        int64_t groupID = [[info objectForKey:@"groupid"]longLongValue];
                        [self.delegate createGroupSuccess:groupID];
                    }
                }];
            }
        }];
    }else{
        [SVProgressHUD showWithStatus:NSLocalizedString(@"邀请中...", nil) maskType:SVProgressHUDMaskTypeBlack];
        
        [[LDClient sharedInstance].groupMembers addMembersList:[contactList selectedItems] verifyInfo:@"" completion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate respondsToSelector:@selector(addMemberSuccess)]) {
                        [self.delegate addMemberSuccess];
                    }
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
            }

        }];
    }
}

#pragma mark - Table view data source
//响应点击索引时的委托方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21;
}
//索引
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    _creatTable.sectionIndexColor = RGBACOLOR(144, 144, 144, 1);
//    return [self.createDataSet sectionsKeysValue];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [contactList numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contactList numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section{
    if ([contactList numberOfRowsInSection:section]>0) {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 150, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor grayColor];
        [title setFont:[UIFont systemFontOfSize:14]];
        title.text = [contactList sectionIndexTitle:section];
        [header addSubview:title];
        return header;
    }
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDCreatGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDCreatGroupCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath forTableView:tableView];
    return cell;
}

#pragma mark - Cell Configuration

- (void)configureCell:(LDCreatGroupCell *)cell atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView
{
    LDContactModel *contact = (LDContactModel *)[contactList itemAtIndexPath:indexPath];
    [cell bindData:contact];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDContactModel *buddy = (LDContactModel *)[contactList itemAtIndexPath:indexPath];
    if ([[contactList defaultSelectedItems] containsObject:buddy]) {
        return;
    }
    if (![[contactList selectedItems] containsObject:buddy]) {
        [contactList addSelectedItem:buddy];
    }else{
        [contactList delSelectedItem:buddy];
    }

    [self touchModifyMemberButton];
    [tableView reloadData];
}

// 响应 选中成员并在底部显示方法
-(void)touchModifyMemberButton
{
    // 如果没有选择的成员对象，删除底部view
    UIView *contactHorizontalView = (UIView *)[self.view viewWithTag:1001];
    if (contactHorizontalView) {
        [contactHorizontalView removeFromSuperview];
    }
    
    // 调整tableview位置
    if([contactList selectedItems].count == 0){
        _creatTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _bottomLayout.constant = 0.0f;
    }else{
        _creatTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-90);
        _bottomLayout.constant = 90.0f;
    }
    
    // 构建底部选中成员view
    NSMutableArray *contactHorizontalArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<[contactList selectedItems].count; i++) {
        LDContactModel *chatName = (LDContactModel *)[[contactList selectedItems] objectAtIndex:i];
        ContactListItem *item1 = [[ContactListItem alloc] initWithFrame:CGRectZero  TinyBuddyBean:chatName];
        [contactHorizontalArray addObject:item1];
    }
    
    if (contactHorizontalArray.count > 0) {
        // 显示被选中的成员图标
        ContactHorizontalList *contactHorizontalList = [[ContactHorizontalList alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 80,[UIScreen mainScreen].bounds.size.width, 80) title:[NSString stringWithFormat:@"%lu位成员", (unsigned long)[contactList selectedItems].count] items:contactHorizontalArray];
        contactHorizontalList.delegate = self;
        contactHorizontalList.tag = 1001;
        // 自动滚动到最右部
        [contactHorizontalList.scrollView scrollRectToVisible:CGRectMake(0, 20, contactHorizontalList.scrollView.contentSize.width, 60) animated:YES];
        // 增加新页面
        [self.view addSubview: contactHorizontalList];
    }
}

- (void)touchDeleteMemberButton:(ContactListItem*)sender{
    [_creatTable reloadData];
    [self touchModifyMemberButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
