//
//  LDContactGroupInfoView.m
//  Linkdood
//
//  Created by VRV on 15/12/10.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDGroupViewController.h"
#import "LDGroupMembersViewController.h"
#import "LDGroupNoticeViewController.h"
#import "LDChangeGroupNameViewController.h"
#import "LDGroupTransferViewController.h"
#import "LDChooseMemberController.h"

@interface LDGroupViewController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *groupNameCell;
@property (weak, nonatomic) IBOutlet UISwitch *groupVSwitch;
@property (weak, nonatomic) IBOutlet UILabel *msgSetLab;
@property (weak, nonatomic) IBOutlet UISwitch *msgTopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *inviteFriendSwitch;
@property (weak, nonatomic) IBOutlet UILabel *identifyTextLab;
@property (weak, nonatomic) IBOutlet UILabel *msgNoticeLab;
@property (weak, nonatomic) IBOutlet UISwitch *groupSearch;
@property (weak, nonatomic) IBOutlet UISwitch *groupPrivateChat;
@property (weak, nonatomic) IBOutlet UISwitch *allowShowMessage;
@property (weak, nonatomic) IBOutlet UILabel *transGroup;

@property (nonatomic,strong) LDChatModel *chatModel;
@end

@implementation LDGroupViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"群设置", nil);
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [_groupModel loadGroupInfo:group_info completion:^(LDGroupModel *groupInfo) {
        [self initView];
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    [_avatar setCornerRadius:_avatar.width/2];
    [self updateGroupView];
    
    LDGroupMemberModel *member = (LDGroupMemberModel *)[[LDClient sharedInstance].groupMembers itemWithID:MYSELF.ID];
    if (member.userType > 1){
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"modify_icon"]];
        [_avatar addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modifyIcon)];
        [_avatar addGestureRecognizer:tap];
        [_avatar setUserInteractionEnabled:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNameNotificationHandler:) name:@"groupNameNotification" object:nil];//更改名称通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNoticeNotificationHandler:) name:@"groupNoticeNotification" object:nil];//更改群公告通知
    
    [self initView];
}

- (void)initView
{
    //消息接收方式
    switch (_groupModel.receiveMsgType) {
        case 1:
            _msgSetLab.text = @"接收消息并通知";
            break;
        case 2:
            _msgSetLab.text = @"不通知仅显示数字";
            break;
        case 3:
            _msgSetLab.text = @"免打扰";
            break;
        default:
            break;
    }
    
    //V标
    _groupVSwitch.on = _groupModel.vSign == 0?NO:YES;
    
    //置顶
    _chatModel = (LDChatModel *)[[LDClient sharedInstance].chatListModel itemWithID:_groupModel.ID];
    if ([_chatModel isTopChat] == YES) {
        _msgTopSwitch.on = YES;
    }else{
        _msgTopSwitch.on = NO;
    }
    
    //加群权限
    switch (_groupModel.verifyType) {
        case 1:
            _identifyTextLab.text = @"不允许任何人添加";
            break;
        case 2:
            _identifyTextLab.text = @"需要验证信息";
            break;
        case 3:
            _identifyTextLab.text = @"允许任何人添加";
            break;
        default:
            break;
    }
    
    //是否允许群成员邀请
    _inviteFriendSwitch.on = _groupModel.isAllow == 1?YES:NO;
    
    //消息通知内容
    switch (_groupModel.receiveMsgContent) {
        case 1:
            _msgNoticeLab.text = @"显示详情";
            break;
        case 2:
            _msgNoticeLab.text = @"只显示发送者消息";
            break;
        case 3:
            _msgNoticeLab.text = @"隐藏详情";
            break;
        default:
            break;
    }
    
    //是否允许被搜索
    _groupSearch.on = _groupModel.isSearch == 1?YES:NO;
    
    //是否允许私信聊天
    _groupPrivateChat.on = _groupModel.isAllowPrivateTalk == 1?YES:NO;
    
    //是否允许开启群消息通知显示详情
    _allowShowMessage.on = _groupModel.notificationState == 1?YES:NO;
    
    [_groupVSwitch addTarget:self action:@selector(changeVsign:) forControlEvents:UIControlEventValueChanged];
    [_msgTopSwitch addTarget:self action:@selector(msgTop:) forControlEvents:UIControlEventValueChanged];
    [_inviteFriendSwitch addTarget:self action:@selector(inviteFriend:) forControlEvents:UIControlEventValueChanged];
    [_groupSearch addTarget:self action:@selector(groupSearch:) forControlEvents:UIControlEventValueChanged];
    [_groupPrivateChat addTarget:self action:@selector(groupPrivateChat:) forControlEvents:UIControlEventValueChanged];
    [_allowShowMessage addTarget:self action:@selector(allowShowMessage:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    [self updateGroupView];
    
    [[LDNotify sharedInstance] headerRefreshMoniter:^(LDItemModel *item) {
        if (item.ID == self.groupModel.ID) {
            [self updateGroupView];
        }
    }];
}

//设置是否允许群成员邀请好友
- (void)inviteFriend:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    __block LDGroupViewController* controller = self;
    _groupModel.isAllow = isButtonOn == YES?1:2;
    [_groupModel setGroupVerify:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            controller.inviteFriendSwitch.on = !isButtonOn;
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

//设置是否允许被搜索
- (void)groupSearch:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    __block LDGroupViewController* controller = self;
    LDGroupModel *group = [[LDGroupModel alloc] initWithID:_groupModel.ID];
    group.isSearch = switchButton.on?1:2;
    [group updateGroupInfo:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            controller.groupSearch.on = !switchButton.on;
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

//设置是否允许私信聊天
- (void)groupPrivateChat:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    __block LDGroupViewController* controller = self;
    LDGroupModel *group = [[LDGroupModel alloc] initWithID:_groupModel.ID];
    group.isAllowPrivateTalk = switchButton.on?1:0;
    [group updateGroupInfo:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            controller.inviteFriendSwitch.on = !switchButton.on;
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

//设置是否允许显示群消息通知详情
- (void)allowShowMessage:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    __block LDGroupViewController* controller = self;
    LDGroupModel *group = [[LDGroupModel alloc] initWithID:_groupModel.ID];
    group.notificationState = switchButton.on?1:2;
    [group updateGroupInfo:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            controller.inviteFriendSwitch.on = !switchButton.on;
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

//设置v标群
- (void)changeVsign:(UISwitch*)sender
{
    [_groupModel setGroupVsign:^(NSError *error) {
        if (error) {
            [sender setOn:!sender.isOn];
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

//消息置顶设置
-(void)msgTop:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [[LDClient sharedInstance].chatListModel makeTopChat:_chatModel completion:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            _msgTopSwitch.on = !isButtonOn;
            [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (void)updateGroupView{
    if (_groupModel) {
        _name.text = _groupModel.groupName;
        _memeberCount.text = [NSString stringWithFormat:@"%ld",(long)[[LDClient sharedInstance].groupMembers numberOfItems]];
        _notice.text = _groupModel.bulletin;
        [[LDClient sharedInstance] avatar:_groupModel.avatarUrl withDefault:@"GroupIcon" complete:^(UIImage *avatar) {
            [_avatar setImage:avatar];
        }];
        
        [_transGroup setText:MYSELF.ID == _groupModel.createrID?@"解散群":@"退出群"];
        
        [self.tableView reloadData];
    }
    if (MYSELF.ID == self.groupModel.createrID) {
        _groupNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

//群名称更改通知
-(void) groupNameNotificationHandler:(NSNotification *) notification{
    _name.text = [notification object];
}
//群公告更改通知
-(void) groupNoticeNotificationHandler:(NSNotification *) notification{
    _notice.text = [notification object];
}

-(void)cancelToChoose{
    [[self navigationController] popViewControllerAnimated:YES];
}

//修改群头像
- (void)modifyIcon{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else{
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];
}

-(void)tranOrDiscolveGroup{
    if (MYSELF.ID == self.groupModel.createrID) {
        //解散群
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定解散群吗?" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"解散中...", nil) maskType:SVProgressHUDMaskTypeBlack];
            [[LDClient sharedInstance].groupListModel dismissGroup:_groupModel completion:^(NSError *error) {
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"解散成功" maskType:SVProgressHUDMaskTypeBlack];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showSuccessWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                }
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出群吗?" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"退出中...", nil) maskType:SVProgressHUDMaskTypeBlack];
            [[LDClient sharedInstance].groupListModel quitGroup:_groupModel completion:^(NSError *error) {
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"退出成功" maskType:SVProgressHUDMaskTypeBlack];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showSuccessWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                }
            }];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)transformGroup{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    LDGroupTransferViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupTransferViewController"];
    vc.groupModel = _groupModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    return;
                    break;
            }
        }
        else{
            if (buttonIndex == actionSheet.cancelButtonIndex) {
                return;
            }
            else{
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [[info objectForKey:@"UIImagePickerControllerEditedImage"] fixOrientation];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *avatar_Path = [APP_TMPPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar_%f.jpg", time]];
    [UIImageJPEGRepresentation(image,0.6) writeToFile:avatar_Path atomically:YES];
    
    [SVProgressHUD showWithStatus:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    LDGroupModel *group = [[LDGroupModel alloc] initWithID:_groupModel.ID];
    group.avatarUrl = avatar_Path;
    [group modifyGroupIcon:^(NSError *error) {
           if(!error){
               [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
               [self updateGroupView];
           }else{
               [SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
           }

    }];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row = 0;
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 4;
    }else if (section == 3){
        LDGroupMemberModel *member = (LDGroupMemberModel*)[[LDClient sharedInstance].groupMembers itemWithID:MYSELF.ID];
        if (member && member.userType > 1) {
            row = 5;
        }
    }
    if(section == tableView.numberOfSections - 1){
        row = (MYSELF.ID == self.groupModel.createrID?2:1);
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section = tableView.numberOfSections - 1?0.1:20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDGroupMemberModel *member = (LDGroupMemberModel *)[[LDClient sharedInstance].groupMembers itemWithID:MYSELF.ID];
    if (member.userType > 1 && indexPath.section == 0){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        LDChangeGroupNameViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDChangeGroupNameViewController"];
        vc.groupModel = _groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        LDGroupMembersViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupMembersViewController"];
        vc.groupModel = _groupModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.section == 1 && indexPath.row == 1){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        LDGroupNoticeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupNoticeViewController"];
        vc.groupModel = _groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"接收消息并通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeNotificationType:notification_type_recevice stringLab:@"接收消息并通知"];
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"不通知仅显示数字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeNotificationType:notification_type_badge stringLab:@"不通知仅显示数字"];
        }];
        UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"免打扰" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeNotificationType:notification_type_disable stringLab:@"免打扰"];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [alertController addAction:actionThree];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"显示详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeNotificationContent:notification_content_detail stringLab:@"显示详情"];
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"只显示发送者消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeNotificationContent:notification_content_from stringLab:@"只显示发送者消息"];
        }];
        UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"隐藏详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeNotificationContent:notification_content_hide stringLab:@"隐藏详情"];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [alertController addAction:actionThree];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"不允许任何人添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self identifyText:1 stringLab:@"不允许任何人添加"];
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"需要验证信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self identifyText:2 stringLab:@"需要验证信息"];
        }];
        UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"允许任何人添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self identifyText:3 stringLab:@"允许任何人添加"];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [alertController addAction:actionThree];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if(indexPath.section == tableView.numberOfSections - 1){
        if(indexPath.row == 0){
            [self tranOrDiscolveGroup];
        }
        if(indexPath.row == 1){
            [self transformGroup];
        }
    }
}

//消息设置
- (void)changeNotificationType:(notification_type)msgType stringLab:(NSString *)labStr
{
    if (![_msgSetLab.text isEqualToString:labStr]) {
        [_groupModel changeNotificationType:msgType completion:^(NSError *error) {
            if (error == nil) {
                _msgSetLab.text = labStr;
                [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}
//消息通知内容
- (void)changeNotificationContent:(notification_content)msgContent stringLab:(NSString *)labStr{
    if (![_msgSetLab.text isEqualToString:labStr]) {
        [_groupModel changeNotificationContent:msgContent completion:^(NSError *error) {
            if (error == nil) {
                _msgNoticeLab.text = labStr;
                [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}

//身份验证
- (void)identifyText:(int)msgType stringLab:(NSString *)labStr{
    if (![_msgSetLab.text isEqualToString:labStr]) {
        __block LDGroupViewController* controller = self;
        _groupModel.verifyType = msgType;
        [_groupModel setGroupVerify:^(NSError *error) {
            if (error == nil) {
                controller.identifyTextLab.text = labStr;
                [SVProgressHUD showSuccessWithStatus:@"更改成功" maskType:SVProgressHUDMaskTypeBlack];
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"更改失败" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}

@end
