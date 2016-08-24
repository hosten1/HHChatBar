//
//  LDGroupPrivateChatViewController.m
//  Linkdood
//
//  Created by yue on 6/21/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDGroupPrivateChatViewController.h"
#import "LDGroupPrivateChatCell.h"

@implementation LDGroupPrivateChatViewController{
    LDGroupMemberListModel *members;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    members = [LDClient sharedInstance].groupMembers;
    [members assembleData];
    [members setDefaultSelectItems:@[(LDGroupMemberModel *)[members itemWithID:MYSELF.ID]]];
    
    if(self.isDirective){
        self.title = NSLocalizedString(@"选择要@的人", nil);
    }else{
        self.title = NSLocalizedString(@"群内私聊", nil);
    }
    
    [_groupMemberTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    _groupMemberTable.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.navigationController.navigationBar.translucent = NO;
    
    _groupMemberTable.delegate=self;
    _groupMemberTable.dataSource=self;
    _groupMemberTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.groupMemberTable reloadData];
    [self touchModifyMemberButton];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)chooseDone{
    if ([members selectedItems].count == 0) {
        if ([self.delegate respondsToSelector:@selector(selectSuccess:)]) {
            [self.delegate selectSuccess:@[]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    NSMutableArray *pMembers = [[NSMutableArray alloc]init];
    for (LDGroupMemberModel *obj in [members selectedItems]) {
        [pMembers addObject:[NSNumber numberWithLongLong:obj.ID]];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectSuccess:)]) {
        [self.delegate selectSuccess:pMembers];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
//响应点击索引时的委托方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [members numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [members numberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section{
    if ([members numberOfRowsInSection:section]>0) {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 150, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor grayColor];
        [title setFont:[UIFont systemFontOfSize:14]];
        title.text = [members sectionIndexTitle:section];
        [header addSubview:title];
        return header;
    }
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDGroupPrivateChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseMemCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath forTableView:tableView];
    return cell;
}

#pragma mark - Cell Configuration

- (void)configureCell:(LDGroupPrivateChatCell *)cell atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView
{
    LDGroupMemberModel *contact = (LDGroupMemberModel *)[members itemAtIndexPath:indexPath];
    [cell bindData:contact];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDGroupMemberModel *buddy = (LDGroupMemberModel *)[members itemAtIndexPath:indexPath];
    if ([[members defaultSelectedItems] containsLDItem:buddy]) {
        return;
    }
    
    if ([members selectedItems].count == 5 && ![[members selectedItems]containsLDItem:buddy]) {
        return;
    }
    
    if (![[members selectedItems] containsLDItem:buddy]) {
        [members addSelectedItem:buddy];
    }else{
        [members delSelectedItem:buddy];
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
    if([members selectedItems].count == 0){
        _groupMemberTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _bottomLayout.constant = 0.0f;
    }else{
        _groupMemberTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-90);
        _bottomLayout.constant = 90.0f;
    }
    
    // 构建底部选中成员view
    NSMutableArray *contactHorizontalArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<[members selectedItems].count; i++) {
        LDContactModel *chatName = (LDContactModel *)[[members selectedItems] objectAtIndex:i];
        ContactListItem *item1 = [[ContactListItem alloc] initWithFrame:CGRectZero  TinyBuddyBean:chatName];
        [contactHorizontalArray addObject:item1];
    }
    
    if (contactHorizontalArray.count > 0) {
        // 显示被选中的成员图标
        ContactHorizontalList *contactHorizontalList = [[ContactHorizontalList alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 80,[UIScreen mainScreen].bounds.size.width, 80) title:[NSString stringWithFormat:@"%lu位成员", (unsigned long)[members selectedItems].count] items:contactHorizontalArray];
        contactHorizontalList.delegate = self;
        contactHorizontalList.tag = 1001;
        // 自动滚动到最右部
        [contactHorizontalList.scrollView scrollRectToVisible:CGRectMake(0, 20, contactHorizontalList.scrollView.contentSize.width, 60) animated:YES];
        // 增加新页面
        [self.view addSubview: contactHorizontalList];
    }
}

- (void)touchDeleteMemberButton:(ContactListItem*)sender{
    [_groupMemberTable reloadData];
    [self touchModifyMemberButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
