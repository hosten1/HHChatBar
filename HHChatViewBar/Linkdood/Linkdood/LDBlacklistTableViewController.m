//
//  LDBlacklistTableViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/5/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDBlacklistTableViewController.h"
#import "LDBlacklistCell.h"
#import "LDChooseMemberController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

@interface LDBlacklistTableViewController ()<MGSwipeTableCellDelegate>
@property(strong,nonatomic)NSArray *blackIDArray;
@property(strong,nonatomic)LDBlackContactsModel *blackModel;
@end

@implementation LDBlacklistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBlacklist)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    _blackModel = [[LDBlackContactsModel alloc]init];
    self.title = @"黑名单";
    
    [_blackModel requestBlackList:^(NSError *error, NSArray<NSNumber *> *members) {
        if (!error) {
            self.blackIDArray = members;
            [self.tableView reloadData];
        }else{
            NSLog(@"出错了");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  增加黑名单好友
 */
-(void)addBlacklist{
    UIStoryboard *contact = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    LDChooseMemberController *addBlackVc = [contact instantiateViewControllerWithIdentifier:@"LDChooseMemberController"];
    addBlackVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addBlackVc animated:YES];
 
}
/**
 *  创建向左滑动的按钮
 *
 *  @param number 按钮的个数
 *
 *  @return 添加的按钮
 */
-(NSArray *) createLeftButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSArray *TitleArr = @[[NSString stringWithFormat: @"恢复好友"]];
    
    UIColor * colors[1] = {
        [UIColor colorWithWhite:0.600 alpha:1.000]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:TitleArr[i] icon:nil backgroundColor:colors[i] padding:15 callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"这里是按钮的回调方法!");
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.blackIDArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LDBlacklistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDBlacklistCell"];
    if ([self.blackIDArray count]) {
        int64_t blackModelID = [self.blackIDArray[indexPath.row] longLongValue];
        LDUserModel *USER = [[LDUserModel alloc] initWithID:blackModelID];
        [USER loadUserInfo:^(LDUserModel *userInfo) {
            [cell setUserModel:USER];
        }];
    }
    cell.allowsMultipleSwipe = YES;
    cell.delegate = self;
    cell.rightButtons = [self createLeftButtons:1];
    cell.rightSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//点击按钮的时候回调
-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion{
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    LDUserModel *contact = [[LDUserModel alloc] initWithID:[self.blackIDArray[path.row] longLongValue]];
    LDBlackContactsModel* blackModel = [[LDBlackContactsModel alloc]init];
    [blackModel removeContactsFromBlackList:@[contact] completion:^(NSError *error) {
        if (!error) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"恢复成功", nil) maskType:SVProgressHUDMaskTypeBlack];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD dismiss];
            });
            
            
            
        }else{
            [SVProgressHUD showWithStatus:NSLocalizedString(@"恢复失败", nil) maskType:SVProgressHUDMaskTypeBlack];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });

        }
    }];

    return YES;
}

@end
