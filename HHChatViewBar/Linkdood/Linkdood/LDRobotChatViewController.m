//
//  LDRobotChatViewController.m
//  Linkdood
//
//  Created by 王越 on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDRobotChatViewController.h"
#import "HHChatBarView.h"

@interface LDRobotChatViewController ()<HHChatBarDelegate>
@property(nonatomic,strong)HHChatBarView *chatBar;
@property(nonatomic,copy)NSDictionary *robotMenuItemInfo;
@property(nonatomic,assign)CGRect oldInputBarFrame;
@property(nonatomic,assign)BOOL isOpenChatBar;

@end

@implementation LDRobotChatViewController


-(void)loadView
{
    [super loadView];
    if (_robot) {
        [self setNavigationItem:_robot];
    }else{
        _robot = [[LDRobotModel alloc] initWithID:self.chatModel.ID];
        [_robot loadRobotInfo:^(LDRobotModel *robotInfo) {
            self.robot = robotInfo;
            [self setNavigationItem:_robot];
        }];
    }
}
-(HHChatBarView *)chatBar{
    if (!_chatBar) {
        HHChatBarView *chat = [[HHChatBarView alloc]initWithDictionary:nil];
        chat.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        chat.leftBtn.alpha = 0.0f;
        _chatBar = chat;
    }
    return _chatBar;
}
- (void)setNavigationItem:(LDRobotModel*)item
{
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBar setFrame:(CGRect){0,0,25,25}];
    [rightBar addTarget:self action:@selector(showRobotInfo) forControlEvents:UIControlEventTouchUpInside];
    [rightBar setCornerRadius:12.5];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBar]];
    [[LDClient sharedInstance] avatar:item.appIcon withDefault:@"robot" complete:^(UIImage *avatar) {
        [rightBar setImage:avatar forState:UIControlStateNormal];
    }];
    [self.navigationItem setTitle:item.appName];
}
- (void)showRobotInfo
{
    
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"robot"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatBar.ChatDelegate = self;
    self.oldInputBarFrame = self.inputToolbar.frame;
    self.inputToolbar.contentView.leftBarButtonWidth = 30;
    [self addObserver:self forKeyPath:@"robot" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark -- 点击左边按钮切换
-(void)didPressLeftButton:(UIButton *)sender{
    if (self.inputToolbar.jsq_showExtendView) {
        [self.inputToolbar hideExtendViewWithAnimated:NO];
        
    }
    [self.inputToolbar.contentView.textView resignFirstResponder];
    if (!_isOpenChatBar) {
        [self.view addSubview:self.chatBar];
        [UIView animateWithDuration:0.3f animations:^{
             self.inputToolbar.contentView.leftBarButtonItem.alpha = 0.0f;
             self.inputToolbar.preferredDefaultHeight = 0.0f;
        } completion:^(BOOL finished) {
            self.inputToolbar.hidden = YES;
        }];
        [UIView animateWithDuration:0.7f animations:^{
            self.chatBar.hidden = NO;
            self.chatBar.leftBtn.alpha = 1.0;
            self.chatBar.frame = CGRectMake(0, SCREEN_HEIGHT-55, SCREEN_WIDTH, 55);
        } completion:^(BOOL finished) {
            self.isOpenChatBar = YES;
        }];

   
    }
     
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark jsq
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *msgFrom = @"robot";
    NSString *avatar = _robot.appIcon;
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    LDUserModel *mySelf = MYSELF;
    if (message.sendUserID == mySelf.ID) {
        if (mySelf.sex == msg_owner_male) {
            msgFrom = @"MaleIcon";
        }
        if (mySelf.sex == msg_owner_female) {
            msgFrom = @"FemaleIcon";
        }
        avatar = mySelf.avatar;
    }
    __block JSQMessagesAvatarImage *avatarImage = [JSQMessagesAvatarImage avatarWithImage:[UIImage imageNamed:msgFrom]];
    [[LDClient sharedInstance] avatar:avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        avatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:avatar diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    }];
    return avatarImage;
}


#pragma mark  --HHChatBardelegate
-(NSInteger)numberOfSectionWithchatBar:(HHChatBarView *)charBar{
    NSArray * arr = self.robotMenuItemInfo[@"menu"];
    return arr.count;
}
-(NSString*)chatBar:(HHChatBarView *)charBar sectionTitleWithIndexPath:(NSIndexPath *)indexPath{
    NSArray * arr = self.robotMenuItemInfo[@"menu"];
    NSString *name = arr[indexPath.section][@"name"];
    return name;
}
-(NSArray*)chatBar:(HHChatBarView *)charBar subPopViewTitleOfRowWithIndexPath:(NSIndexPath *)indexPath{
    NSArray * arr = self.robotMenuItemInfo[@"menu"];
    NSMutableArray *nameArray = [NSMutableArray array];
    NSArray *sub = arr[indexPath.section][@"sub_menu"];
    for (NSDictionary *dic in sub) {
        NSString *name = dic[@"name"];
        [nameArray addObject:name];
    }
    return nameArray;
}
-(void)chatBar:(HHChatBarView *)charBar didSelectIndex:(NSIndexPath *)indexPath{
    NSLog(@"section::%d,row:::%d",indexPath.section,indexPath.row);
}

-(void)chatBar:(HHChatBarView *)charBar didClickRithtButton:(UIButton *)sender{
    if (self.isOpenChatBar) {
        if (self.view) {
            [UIView animateWithDuration:0.3f animations:^{
                self.chatBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,0);
                self.chatBar.leftBtn.alpha = 0.0;
                self.inputToolbar.hidden = NO;
            } completion:^(BOOL finished) {
                self.chatBar.hidden = YES;
                self.isOpenChatBar = NO;
            }];
            [UIView animateWithDuration:0.7f animations:^{
                
                 self.inputToolbar.preferredDefaultHeight = self.oldInputBarFrame.size.height;
                 self.inputToolbar.contentView.leftBarButtonItem.alpha = 1.0f;
            } completion:^(BOOL finished) {
               
            }];
           
           
        }
    }

}
#pragma mark -- 数据监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([change[@"new"] isKindOfClass:[LDRobotModel class]]) {
        LDRobotModel *robot = change[@"new"];
        if (robot.appMenus) {
            self.robotMenuItemInfo = robot.appMenus;
            //        self.chatBar.ChatDelegate = self;
            [self.chatBar setupSubviewItems];
        }else{
            NSLog(@"出错啦");
        }

    }
    
}
@end
