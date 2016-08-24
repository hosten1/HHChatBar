//
//  LDMyselfViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/2/22.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDMyselfViewController.h"
#import "LDAutomaticLoginViewController.h"
#import "AppDelegate.h"

@interface LDMyselfViewController ()

@property (nonatomic, strong) LDUserModel *myself;
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *operate;

@end

@implementation LDMyselfViewController

- (void)awakeFromNib {
    [self.navigationItem setTitle:LOCALIIZED(@"Me")];
    [self.navigationController.tabBarItem setTitle:LOCALIIZED(@"Me")];
    [_portrait setCornerRadius:_portrait.width/2];
    
    self.myself = MYSELF;
    [self addObserver:self forKeyPath:@"myself" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [[LDNotify sharedInstance] myselfInfoMoniter:^(LDUserModel *myself) {
        self.myself = myself;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_operate setText:@"退出登录"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadMyself];
}

- (void)reloadMyself
{
    self.myself = MYSELF;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshMyself];
    });
}

- (void)refreshMyself
{
    _name.text = _myself.name;
    NSString *msgFrom = @"Unisex";
    if (_myself.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (_myself.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    [[LDClient sharedInstance] avatar:_myself.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_portrait setImage:avatar];
    }];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *myselfSB = [UIStoryboard storyboardWithName:@"myself" bundle:nil];
    if (indexPath.section == 0) {
        UIViewController *informationVC = [myselfSB instantiateViewControllerWithIdentifier:@"LDInformationViewController"];
        [informationVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:informationVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        UIViewController *setVC = [myselfSB instantiateViewControllerWithIdentifier:@"LDSysConfigSettingTableViewController"];
        [setVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:setVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        UIViewController *feedbackVC = [myselfSB instantiateViewControllerWithIdentifier:@"LDFeedbackViewController"];
        [feedbackVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        UIViewController *aboutVC = [myselfSB instantiateViewControllerWithIdentifier:@"LDAboutDoodTableViewController"];
        [aboutVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (indexPath.section == 2){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出系统" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction *action) {
            LDAuthModel *authModel = [[LDAuthModel alloc]init];
            [authModel logoff:^(NSError *error) {
                [(AppDelegate*)SYS_DELEGATE logOut];
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"myself"];
}

@end
