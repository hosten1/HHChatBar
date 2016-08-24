//
//  LDContactInfoViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/3/11.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDContactInfoViewController.h"
#import "LDContactHeaderView.h"
#import "LDPersonFooterView.h"
#import "LDSingleChatViewController.h"

@interface LDContactInfoViewController ()<UIActionSheetDelegate,LDPersonFooterDelegate,LDContactHeaderViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    LDContactHeaderView *header;
}

@end

@implementation LDContactInfoViewController

-(void)loadView
{
    [super loadView];
    //如果是来自聊天界面的card
    WEAKSELF
    if (_pushFromChatCard) {
        _userModel = [[LDClient sharedInstance] localContact:self.userInfoIDForomChatCard];
        if (!_userModel) {
            _userModel = [[LDUserModel alloc] initWithID:self.userInfoIDForomChatCard];
            [_userModel loadUserInfo:^(LDUserModel *userInfo) {
                if (userInfo != nil) {
                    weakSelf.contactModel = (LDContactModel*)userInfo;
                     [self refreshContactInfo];
                    if (header) {
                        [header refreshWithUserInfo:_contactModel];
                    }
                }
                    
            }];
        }else{
            _contactModel = (LDContactModel*)_userModel;
            [self refreshContactInfo];
        }
    }else{
        if (!_contactModel && _userModel) {
            _contactModel = [[LDContactModel alloc] initWithID:_userModel.ID];
        }
        //加载详细信息
        [_contactModel loadUserInfo:^(LDUserModel *userInfo) {
            [self refreshContactInfo];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //个人信息头部信息
    if (![[[LDClient sharedInstance] contactListModel] itemWithID:self.contactModel.ID]) {
         header = [[LDContactHeaderView alloc] initWithHeight:160];
    }else{
         header = [[LDContactHeaderView alloc] initWithHeight:200];
    }
   
    [self.tableView setTableHeaderView:header];
    header.delegate = self;
    
    LDPersonFooterView *foot = [[LDPersonFooterView alloc] initWithFrame:CGRectMake(4, 0, SCREEN_WIDTH, 50)];
    if (![[[LDClient sharedInstance] contactListModel] itemWithID:self.contactModel.ID]) {
        [foot addPerson];
    }else{
        [foot sendMessage];
            
        UIButton *operate = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
        [operate setImage:[UIImage imageNamed:@"navMore"] forState:UIControlStateNormal];
        [operate addTarget:self action:@selector(functionEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:operate]];
        
    }
    
    foot.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = foot;
    
    foot.delegate = self;
    
    [self refreshContactInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [header refreshWithUserInfo:_contactModel];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)refreshContactInfo
{
    if (_contactModel.phones.count > 0) {
        NSString *phone = [_contactModel.phones firstObject];
        if (phone.length > 4) {
            [_phone setText:[phone substringFromIndex:4]];
        }else{
            [_phone setText:phone];
        }
    }
    if (_contactModel.emails.count > 0) {
        [_email setText:[_contactModel.emails firstObject]];
    }
    
    if (_contactModel.extend != nil && [_contactModel.extend jsonType] == JSON_TYPE_ARRAY) {
        NSArray *extendInfo = [_contactModel.extend objectFromJSONString];
        if (extendInfo != nil) {
            NSDictionary *extendDic = [extendInfo firstObject];
            [_position setText:[extendDic objectForKey:@"duty"]];
            NSString *enmail = [extendDic objectForKey:@"enmail"];
            if (enmail && enmail.length > 0) {
                [_email setText:[extendDic objectForKey:@"enmail"]];
            }
        }
    }
    
    if (_contactModel.notificationContent == notification_content_detail) {
        [_content setText:@"显示消息详情"];
    }
    if (_contactModel.notificationContent == notification_content_from) {
        [_content setText:@"显示消息来源"];
    }
    if (_contactModel.notificationContent == notification_content_hide) {
        [_content setText:@"隐藏消息内容"];
    }
    
    if (_contactModel.notificationType == notification_type_recevice) {
        [_type setText:@"接收新消息通知"];
    }
    if (_contactModel.notificationType == notification_type_badge) {
        [_type setText:@"仅显示新消息数"];
    }
    if (_contactModel.notificationType == notification_type_disable) {
        [_type setText:@"不接收新消息通知"];
    }
}

-(void)functionEvent{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"更多选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除好友",@"加入黑名单", nil];
    [actionSheet showInView:self.view];
    objc_setAssociatedObject(actionSheet, "type", @4, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sendMess{
    if (_pushFromChat) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        LDSingleChatViewController *vc = [[LDSingleChatViewController alloc]initWithTarget:_contactModel.ID];
        [vc setSenderDisplayName:_contactModel.name];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addFriend{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证信息" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = [NSString stringWithFormat:@"我是%@",MYSELF.name];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        [[LDClient sharedInstance].contactListModel addContact:_userModel
                                                    verifyInfo:@[textField.text]
                                                        remark:nil
                                                    completion:^(NSError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"已发送好友邀请" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}

#pragma mark tableDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"接收新消息通知",@"仅显示新消息数",@"不接收新消息通知", nil];
            [actionSheet showInView:self.view];
            objc_setAssociatedObject(actionSheet, "type", @2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        if (indexPath.row == 1) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"显示消息详情",@"显示消息来源",@"隐藏消息内容", nil];
            [actionSheet showInView:self.view];
            objc_setAssociatedObject(actionSheet, "type", @3, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [header statusChangeScroll:scrollView];
}

- (IBAction)phoneOperate:(id)sender
{
    if (!_phone.text || _phone.text.length == 0) {
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"联系:%@",_phone.text] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打电话",@"发送短信", nil];
    [actionSheet showInView:self.view];
    objc_setAssociatedObject(actionSheet, "type", @1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IBAction)emailOperate:(id)sender
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    NSNumber *type = objc_getAssociatedObject(actionSheet, "type");
    if ([type intValue] == 1) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:[[_phone.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""]]]];
        }
        if (buttonIndex == 1) {
            
        }
    }
    if ([type intValue] == 2) {
        notification_type type = notification_type_recevice;
        if (buttonIndex == 1) {
            type = notification_type_badge;
        }
        if (buttonIndex == 2) {
            type = notification_type_disable;
        }
        [_contactModel changeNotificationaType:type completion:^(NSError *error) {
            [self refreshContactInfo];
        }];
    }
    if ([type intValue] == 3) {
        notification_content content = notification_content_detail;
        if (buttonIndex == 1) {
            content = notification_content_from;
        }
        if (buttonIndex == 2) {
            content = notification_content_hide;
        }
        [_contactModel changeNotificationContent:content completion:^(NSError *error) {
            [self refreshContactInfo];
        }];
    }
    if ([type intValue] == 4) {
        if(buttonIndex == actionSheet.destructiveButtonIndex){
            [[LDClient sharedInstance].contactListModel removeContact:_contactModel delEither:YES completion:^(NSError *error) {
                if (!error) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [SVProgressHUD showSuccessWithStatus:@"删除成功" maskType:SVProgressHUDMaskTypeBlack];
                }
            }];
        }else if(buttonIndex == actionSheet.firstOtherButtonIndex){
            LDBlackContactsModel* blackModel = [[LDBlackContactsModel alloc]init];
            NSMutableArray *tempOfContact = [NSMutableArray array];
            [tempOfContact addObject:_contactModel];
            
            [blackModel addContactsToBlackList:tempOfContact completion:^(NSError *error) {
                if (!error) {
                    [SVProgressHUD showWithStatus:NSLocalizedString(@"加入成功", nil) maskType:SVProgressHUDMaskTypeBlack];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [SVProgressHUD dismiss];
                    });
                    
                }else{
                    [SVProgressHUD showWithStatus:NSLocalizedString(@"加入失败", nil) maskType:SVProgressHUDMaskTypeBlack];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [SVProgressHUD dismiss];
                    });
                    NSLog(@"%@",error);
                    
                }
            }];
        }
    }
}

#pragma mark   ---LDContactHeaderViewDelegate
-(void)changeRemarkWithContain:(LDContactModel *)contact remark:(NSString *)remarkString{
   
    contact.remark = remarkString;
    [contact resetRemark:^(NSError *error) {
        if (!error) {
            NSLog(@"好友昵称 修改成功");
        }else{
            NSLog(@"好友昵称  修改失败");
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
