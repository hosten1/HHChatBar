//
//  LDChatRoomMessageController.m
//  Linkdood
//
//  Created by VRV2 on 16/7/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDChatRoomMessageController.h"
#import "LDChatRoomMessageCell.h"
#import "LDSingleChatViewController.h"
#import "LDGroupChatViewController.h"
#import "LDRobotChatViewController.h"
#import "LDCreateGroupViewController.h"
#import "LDSearchContactViewController.h"
#import "XHPopMenuItem.h"
#import "XHPopMenu.h"
#import "KYCuteView.h"

@interface LDChatRoomMessageController ()<UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic,assign) NSInteger topIndex;
@property (nonatomic,strong) XHPopMenu *popMenu;
@property (strong,nonatomic) LDChatListModel *chatList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong)UISearchDisplayController *searchController;
@property (strong,nonatomic)NSMutableArray *messageAry;
@property (strong,nonatomic)KYCuteView *cuteView;
//选中的cell
@property (strong, nonatomic) UITableViewCell *selectedCell;



@end

@implementation LDChatRoomMessageController

- (void)awakeFromNib{
    [self.navigationItem setTitle:@"房间会话列表"];
}

- (void)loadView
{
    [super loadView];
    [[LDNotify sharedInstance] chatListMoniter:^(LDChatListModel *chatList) {
        [self refreshMessage];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage) name:@"refreshMessage" object:nil];
    
    UIButton *button = [NSString createGoBackButton:@"addItemButton"];
    [button addTarget:self action:@selector(showMenuOnView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchBar.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    [self.searchController setActive:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden=YES;

    //清空保存的群成员数组选择
    [[[LDClient sharedInstance].groupMembers selectedItems] removeAllObjects];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //监听新消息
    [[LDNotify sharedInstance] messageMoniter:^(LDMessageModel *message) {
        [self refreshMessage];
    } forTarget:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_popMenu dissMissPopMenuAnimatedOnMenuSelected:YES];
}

- (void)refreshMessage{
    //更新最近会话列表
    self.chatList = [LDClient sharedInstance].chatListModel;
    [self.tableView reloadData];
}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_messageAry count];
        
    }
    return [self.roomModelFromChatView.chatList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        LDChatRoomMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LDChatRoomMessageCell"];
        [cell setSearchChatModel:_messageAry[indexPath.row]];
        return cell;
    }
    
    LDChatRoomMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDChatRoomMessageCell"];
    
     int64_t targetID =  [self.roomModelFromChatView.chatList[indexPath.row] longLongValue];
     LDChatListModel *listChat = [LDClient sharedInstance].chatListModel;
    for (NSInteger i = 0; i < [listChat numberOfItems]; i++) {
        LDChatModel *moe = (LDChatModel*)[listChat itemAtIndex:i];
        if (moe.lastMsgid == targetID) {
            NSLog(@"fgfgsdfgsfg");
        }
    }
//     LDChatModel *chatModel = (LDChatModel*)[listChat itemWithID:4336917217];
     LDChatModel *chatModel = (LDChatModel*)[listChat itemWithID:targetID];
//     LDChatModel *chatModel = (LDChatModel*)[[LDClient sharedInstance].chatListModel itemWithID:targetID];
    
    [cell setChatModel:chatModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        LDChatModel *chatModel = (LDChatModel*)_messageAry[indexPath.row];
        [chatModel searchMessagesWithKeyword:_searchBar.text.length == 0?@"":_searchBar.text completion:^(NSError *error, LDMessageListModel *chatList) {
            
        }];
    }
    
    int64_t targetID =  [self.roomModelFromChatView.chatList[indexPath.row] longLongValue];
    LDChatListModel *listChat = [LDClient sharedInstance].chatListModel;
    
    LDChatModel *chatModel = (LDChatModel*)[listChat itemWithID:targetID];
    
    LDChatViewController *chatView;
    IDRange range = idRange(chatModel.ID);
    if (range == id_range_USER) {
        chatView = [[LDSingleChatViewController alloc] initWithChat:chatModel];
    }
    if (range == id_range_GROUP) {
        chatView = [[LDGroupChatViewController alloc] initWithChat:chatModel];
    }
    if (range == id_range_ROBOT) {
        chatView = [[LDRobotChatViewController alloc] initWithChat:chatModel];
    }
    [chatView setSenderDisplayName:chatModel.sender];
    [self.navigationController pushViewController:chatView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)receivedMessage:(LDMessageModel *)mess forIndex:(int)index
{
    [self refreshMessage];
}

- (void)showMenuOnView:(UIBarButtonItem *)buttonItem {
    CGPoint point;
    point.x=CGRectZero.origin.x;
    [self.popMenu showMenuOnView:self.navigationController.view atPoint:point];
}

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 2; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"修改名称";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"增加会话";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 0) {
                //修改房间名称
                
            }
            if (index == 1) {
                
            }
        };
    }
    return _popMenu;
}

- (void)createGroupSuccess:(int64_t)groupID{
//    LDGroupChatViewController *vc = [[LDGroupChatViewController alloc]initWithTarget:groupID];
//    vc.hidesBottomBarWhenPushed=YES;
//    vc.senderDisplayName = @"";
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark SearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchController setActive:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [_messageAry removeAllObjects];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
    [[LDClient sharedInstance].chatListModel searchChatWithKeyword:searchText.length == 0?@"":searchText completion:^(NSError *error, NSArray *chats) {
        if (!_messageAry) {
            _messageAry = [[NSMutableArray alloc] initWithArray:chats];
        }else{
            [_messageAry removeAllObjects];
            [_messageAry addObjectsFromArray:chats];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
