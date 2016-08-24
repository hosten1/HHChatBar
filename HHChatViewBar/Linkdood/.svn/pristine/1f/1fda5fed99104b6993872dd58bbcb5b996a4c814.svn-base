//
//  LDMessageViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/2/17.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDMessageViewController.h"
#import "LDSingleChatViewController.h"
#import "LDGroupChatViewController.h"
#import "LDRobotChatViewController.h"
#import "LDCreateGroupViewController.h"
#import "LDSearchContactViewController.h"
#import "LDMultiServerViewController.h"
#import "XHPopMenuItem.h"
#import "XHPopMenu.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "KYCuteView.h"
#import "HQliquidButton.h"
#import "LDChatRoomMessageController.h"
#import "LDRoomMessageCell.h"
#import "AppDelegate.h"
#import "HMScannerController.h"
#import "NSString+LDStringAttribute.h"
#import "LDContactInfoViewController.h"
#import "LDGroupViewController.h"
#import "LDGroupListViewController.h"
#import "LDMyQRViewController.h"
@interface LDMessageViewController ()<UISearchDisplayDelegate,UISearchBarDelegate,MGSwipeTableCellDelegate>

@property (nonatomic,assign) NSInteger topIndex;
@property (nonatomic,strong) XHPopMenu *popMenu;
@property (strong,nonatomic) LDChatListModel *chatList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong)UISearchDisplayController *searchController;
@property (strong,nonatomic)NSMutableArray *messageAry;
@property (strong,nonatomic)HQliquidButton *cuteView;
//选中的cell
@property (strong, nonatomic) UITableViewCell *selectedCell;
//房间(消息分组)
@property(strong,nonatomic)LDRoomListModel *roomList;
@end

@implementation LDMessageViewController

- (void)awakeFromNib{
    [self.navigationItem setTitle:LOCALIIZED(@"CFBundleDisplayName")];
    [self.navigationController.tabBarItem setTitle:LOCALIIZED(@"CFBundleDisplayName")];
    
    CGRect tabFrame =self.tabBarController.tabBar.frame;
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/375;
    float percentX = (0.6/3)*scale;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(x, tabFrame.origin.y+2)];
    redPoint.bagdeLableWidth = 18;
    self.cuteView = redPoint;
    redPoint.maxDistance = 100;
    redPoint.hidden = YES;
    //设置触摸区域的范围
    redPoint.maxTouchDistance = 25;
    [self.tabBarController.tabBar addSubview:redPoint];
    
    //加载最近会话列表
    [[LDNotify sharedInstance] chatListMoniter:^(LDChatListModel *chatList) {
        [self refreshMessage];
        
        //最近会话返回后进行一次apns注册
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //注册apns推送
            LDAuthModel *authModel = [LDClient sharedInstance].loginConfig;
            if (authModel && authModel.password.length > 0) {
                [authModel registerPushToken:[(AppDelegate*)SYS_DELEGATE pushToken] completion:nil];
            }
            
            //子账号登录
            for (LDMultiServerModel *multiServer in [LDClient sharedInstance].multiServerInfo) {
                [multiServer autoLogin:nil];
            }
            
            //任务列表
//            LDTaskMessageListModel *task = [[LDTaskMessageListModel alloc] init];
//            [task querySendMessages:^(NSError *error) {
//                LDTaskMessageModel *tasks = (LDTaskMessageModel*)[task itemAtIndex:0];
//                LDTaskMessageModel *reply = [[LDTaskMessageModel alloc] initWithTaskContent:@"reply"];
//                [reply setRelatedMsgID:tasks.ID];
//                
//                [tasks replyMessages:^(NSError *error, LDChatListModel *taskList) {
//                    
//                }];
//            }];
//            
//            [task queryReceiveMessages:^(NSError *error) {
//                
//            }];
        });
    }];
}

- (void)loadView
{
    [super loadView];

    UIButton *button = [NSString createGoBackButton:@"addItemButton"];
    [button addTarget:self action:@selector(showMenuOnView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *MultiServers = [NSString createGoBackButton:@"MultiServers"];
    [MultiServers addTarget:self action:@selector(showMultiServers:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:MultiServers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage) name:@"refreshMessage" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //自定义搜索框按钮
    [_searchBar setImage:[UIImage imageNamed:@"Message_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    [self.searchController setActive:NO];
    //长按手势,会话分组功能
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
    
    //加载最近会话中的房间
    [self.chatList roomList:^(NSError *error, LDRoomListModel *roomList) {
        [roomList assembleData];
        if ([roomList numberOfItems] != 0) {
            _roomList = roomList;
            MainQue([self.tableView reloadData];);
        }
    }];
    
    //未读消息数刷新
    int unread = [_chatList numberOfUnreadMessage];
    if (unread > 0) {
        self.cuteView.bagdeNumber = unread;
        self.cuteView.hidden = NO;
        WEAKSELF
        self.cuteView.dragLiquidBlock = ^(HQliquidButton *liquid) {
            if (liquid) {
                for (NSInteger i = 0;i < [_chatList numberOfItems];i++) {
                    //设置所有的消息为已经读消息
                    LDChatModel *chat = (LDChatModel*)[weakSelf.chatList itemAtIndex:i];
                    [chat makeMessageReaded];
                }
            }

        };
    }else{
        self.cuteView.hidden = YES;
        //        self.cuteView.frontView.hidden = YES;
        [self.navigationController.tabBarItem setBadgeValue:nil];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unread];

}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    if([self.roomList numberOfItems]){
        return [_chatList numberOfSections]+1;
    }
    return [_chatList numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_messageAry count];
    }
    if([self.roomList numberOfItems] && section == 0){//只要有一个不满足说明不存在，
        return [self.roomList numberOfItems];
    }else{
        if ([self.roomList numberOfItems]) {//当分组不存在的时候，section减一
            return [_chatList numberOfRowsInSection:section-1];
        }else{//当分组不存在的时候，section不变
            return [_chatList numberOfRowsInSection:section];
        }
    }
    return [_chatList numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        LDMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LDMessageCell"];
        [cell setSearchChatModel:_messageAry[indexPath.row]];
        return cell;
    }else{
        if ([self.roomList numberOfItems] && indexPath.section == 0 ){
            LDRoomMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LDRoomMessageCell"];
            LDRoomModel *roomModel = (LDRoomModel*)[self.roomList itemAtIndex:indexPath.row];
            cell.roomModel = roomModel;
            return cell;
        }else{
            NSIndexPath *chatIndexpath = indexPath;
            if ([self.roomList numberOfItems]) {
                chatIndexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
            }
            LDMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDMessageCell"];
            cell.delegate = self;
            cell.allowsMultipleSwipe = YES;
            [cell setChatModel:(LDChatModel*)[_chatList itemAtIndexPath:chatIndexpath]];
            return cell;

        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        LDChatModel *chatModel = (LDChatModel*)_messageAry[indexPath.row];
        [chatModel searchMessagesWithKeyword:_searchBar.text.length == 0?@"":_searchBar.text completion:^(NSError *error, LDMessageListModel *chatList) {
            
        }];
    }else{
        if ([self.roomList numberOfItems] && indexPath.section == 0 ){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LDChatRoomMessageController *vc = [sb instantiateViewControllerWithIdentifier:@"LDChatRoomMessageController"];
            vc.roomModelFromChatView = (LDRoomModel*)[self.roomList itemAtIndex:indexPath.row];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSIndexPath *chatIndexpath = indexPath;
            if ([self.roomList numberOfItems]) {
                chatIndexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
            }
            LDChatModel *chatModel = (LDChatModel*)[_chatList itemAtIndexPath:chatIndexpath];
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
            chatView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatView animated:YES];
        }
    }
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

- (void)showMultiServers:(UIBarButtonItem *)buttonItem {
    LDMultiServerViewController *multiServer = [[LDMultiServerViewController alloc] initWithNibName:@"LDMultiServerViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:multiServer];
    [nav.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"goback"]];
    [nav.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"goback"]];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)showMenuOnView:(UIBarButtonItem *)buttonItem {
    CGPoint point;
    point.x=CGRectZero.origin.x;
    [self.popMenu showMenuOnView:self.navigationController.view atPoint:point];
}

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 3; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"发起群聊";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"添加朋友";
                    break;
                }
                case 2: {
                    imageName = @"contacts_add_sweep";
                    title = @"扫一扫";
                    break;
                }

                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        
        WEAKSELF
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 0) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
                LDCreateGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDCreateGroupViewController"];
                vc.delegate = weakSelf;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
            if (index == 1) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
                LDSearchContactViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDSearchContactViewController"];
                [vc setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            if (index == 2) {
                HMScannerController *scanner = [HMScannerController scannerWithCardName:@"" avatar:nil completion:^(NSString *stringValue) {
                    if ([stringValue subURLStr:stringValue]) {
                        if (stringValue) {//判断是不是连接
                            NSArray *subString = [stringValue componentsSeparatedByString:@"="];
                            int64_t target = [[subString lastObject] longLongValue];
                            if (target) {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self pushViewWithID:target];
                                });
                            }
                            
                        }
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"扫面结果：%@",stringValue] maskType:SVProgressHUDMaskTypeBlack];
                        });
                    }
                    
                }];
                
                [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
                [scanner resopnserToMyCardWithMyQRbackButtonClick:^(UINavigationController *naviController) {
                    if (naviController) {
                        LDMyQRViewController *myQR = [[LDMyQRViewController alloc]init];
                        [naviController pushViewController:myQR animated:YES];
                    }
                }];
                [self showDetailViewController:scanner sender:nil];
            }

        };
    }
    return _popMenu;
}

- (void)createGroupSuccess:(int64_t)groupID{
    LDGroupChatViewController *vc = [[LDGroupChatViewController alloc]initWithTarget:groupID];
    vc.hidesBottomBarWhenPushed=YES;
    vc.senderDisplayName = @"";
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark --MGSwiftTableViewCell 的代理方法

//点击按钮的时候回调
-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion{
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    if ([self.roomList numberOfItems]) {
        path = [NSIndexPath indexPathForRow:path.row inSection:path.section-1];
    }
    LDChatModel *chatModel = (LDChatModel*)[_chatList itemAtIndexPath:path];
    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //删除会话
        [_chatList removeChatRecord:chatModel completion:nil];
    }else if (index == 1){
        //置顶会话
        [_chatList makeTopChat:chatModel completion:nil];
    }
    return YES;
}

#pragma mark --长按手势处理
- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                self.selectedCell = cell;
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                self.selectedCell.hidden = NO;
                self.selectedCell.alpha = 0.98;
            }];
            if (longPress.state == UIGestureRecognizerStateEnded) {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    [self addChatRoomIndex:sourceIndexPath toIndex:indexPath];
                    
                }
                
            }
            break;
        }
            
    }
}
-(void)addChatRoomIndex:(NSIndexPath*)index toIndex:(NSIndexPath*)toIndex{
    if ([self.roomList numberOfItems]) {
        index = [NSIndexPath indexPathForRow:index.row inSection:index.section-1];
        toIndex = [NSIndexPath indexPathForRow:toIndex.row inSection:toIndex.section-1];
    }

    LDChatModel *chatMode = (LDChatModel*) [self.chatList itemAtIndexPath:toIndex];
    LDChatModel *sourceChatMode = (LDChatModel*)[self.chatList itemAtIndexPath:index];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"房间名称设置" message:@"请输入房间名"preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *roomNameFiled = alertController.textFields.firstObject;
        NSString *roomName = roomNameFiled.text;
        LDRoomListModel *room = [[LDRoomListModel alloc]init];
//        @[[NSNumber numberWithLongLong:chatMode.ID],[NSNumber numberWithLongLong:sourceChatMode.ID]
        [room createRoom:roomName withChats:@[chatMode,sourceChatMode]completion:^(NSError *error, LDRoomListModel *roomList) {
            if (!error) {
                //            _ID	int64_t	4336923488
                NSLog(@"成功");
                [self refreshMessage];
                
            }else{
                
                NSLog(@"失败");
            }

        }];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 仿制一个cell生成动画效果
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 根据ID跳转到对应的页面
-(void)pushViewWithID:(int64_t)targetID{
    __block LDItemModel *itemModel;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    IDRange idRange = [[LDClient sharedInstance] idRange:targetID];
    if (idRange == id_range_USER) {
        LDContactInfoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDContactInfoViewController"];
        vc.userInfoIDForomChatCard = targetID;
        [vc setPushFromChatCard:YES];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = self.navigationItem.title;
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(idRange == id_range_GROUP)  {
        LDGroupModel *groupModel = [[LDClient sharedInstance] localGroup:targetID];
        if (!groupModel) {
            [[LDClient sharedInstance].contactListModel contactsWithKey:[NSString stringWithFormat:@"%lld",targetID] onArea:search_area_inside forType:search_type_all completion:^(NSError *error, NSDictionary *info) {
                if (!error) {
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
                    LDGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupViewController"];
                    vc.groupModel = groupModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    NSAssert(error != nil, @"搜索关键字or信息出错");
                }
            }];
        }else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            LDGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupViewController"];
            vc.groupModel = groupModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    if (idRange == id_range_ROBOT) {
        itemModel = [[LDClient sharedInstance] localRobot:targetID];
        if (!itemModel) {
            itemModel = [[LDRobotModel alloc] initWithID:targetID];
            [(LDRobotModel*)itemModel loadRobotInfo:^(LDRobotModel *robotInfo) {
                if (robotInfo != nil) {
                    itemModel = robotInfo;
                    
                }
            }];
        }
    }
    
}

@end
