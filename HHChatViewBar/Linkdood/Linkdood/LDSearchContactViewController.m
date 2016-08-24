//
//  LegendAddBuddyController.m
//  IM
//
//  Created by liuxinbo on 14-8-14.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import "LDSearchContactViewController.h"
#import "LDContactSearchListViewController.h"
#import "LDFaceToFaceViewController.h"
#import "HMScannerController.h"
#import "LDContactInfoViewController.h"
#import "LDGroupViewController.h"
#import "LDGroupListViewController.h"
#import "NSString+LDStringAttribute.h"
#import "LDMyQRViewController.h"
@interface LDSearchContactViewController ()
@end

@implementation LDSearchContactViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title  = @"添加联系人";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.searchTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    
    self.searchTable.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark 用户操作方法
- (void)hideKeyBoard
{
    [self.keyword resignFirstResponder];
}

#pragma mark UITableViewDataSource
// 分节数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }
    return 17;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 34;
    }
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    return view;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LDSearchCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CONTACTS_SEARCH"]];
            [image setFrame:CGRectMake(2, -2, 40, 40)];
            [cell addSubview:image];
            _keyword = [[UITextField alloc] initWithFrame:CGRectMake(47, 2, cell.frame.size.width - 70, 30)];
            [_keyword setEnabled:YES];
            [_keyword setPlaceholder:NSLocalizedString(@"请输入账号/手机号/群号", @"")];
            [_keyword setValue:RGBACOLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
            [_keyword setFont:[UIFont systemFontOfSize:14]];
            [_keyword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [_keyword setTextColor:cell.detailTextLabel.textColor];
            [_keyword setDelegate:self];
            [_keyword setReturnKeyType:UIReturnKeySearch];
            [_keyword setClearButtonMode:UITextFieldViewModeWhileEditing];
            [_keyword becomeFirstResponder];
            [cell addSubview:_keyword];
            break;
        }
        case 1:
        {
            [cell sweapView];
            break;
        }
        case 2:
        {
            [cell faceToFaceSingelView];
            break;
        }
        case 3:
        {
            [cell faceToFaceGrpiopView];
            break;
        }
            
        case 4:
        {
            [cell contactView];
            break;
        }
            
    }
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [_keyword becomeFirstResponder];
    }
    switch (indexPath.section) {
        case 0:
        {
            break;
        }
        case 1:
        {
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

            break;
        }
        case 2:
        {//近距离加好友
            LDFaceToFaceViewController *faceToFace = [[LDFaceToFaceViewController alloc]init];
            faceToFace.isGroup = 0;
            [self.navigationController pushViewController:faceToFace animated:YES];
            break;
        }
        case 3:
        {//近距离加群
            LDFaceToFaceViewController *faceToFace = [[LDFaceToFaceViewController alloc]init];
            faceToFace.isGroup = 1;
            [self.navigationController pushViewController:faceToFace animated:YES];
            
            break;
        }
        case 4:
        {
            
            break;
        }
            
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (sender == self.navigationItem.rightBarButtonItem) {
        return;
    }
//    LDContactSearchListViewController *searchPeople = segue.destinationViewController;
//    NSString *keywordSting = (NSString *)sender;
//    searchPeople.keyword = keywordSting;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.keyword.text = [self.keyword.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self.keyword.text isEqualToString:@""]) {
        return false;
    }

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    LDContactSearchListViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDContactSearchListViewController"];
    vc.keyword = self.keyword.text;
    [self.navigationController pushViewController:vc animated:YES];
    
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
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
