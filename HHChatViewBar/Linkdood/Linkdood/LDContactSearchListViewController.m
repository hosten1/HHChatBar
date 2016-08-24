//
//  IMNew
//
//  Created by VRV on 15/9/17.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import "LDContactSearchListViewController.h"
#import "LDGroupListCell.h"
#import "LDContactListCell.h"
#import "LDContactInfoViewController.h"
#import "LDGroupViewController.h"
#import "LDInformationViewController.h"

@interface LDContactSearchListViewController ()

@property (nonatomic,strong) NSDictionary *searchResultDict;
@end

@implementation LDContactSearchListViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"检索列表", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.resultTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.resultTable setSeparatorColor:RGBACOLOR(219, 219, 222, 1)];
    
    self.resultTable.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    
    //[_resultTable registerNib:[UINib nibWithNibName:@"IMPeopleList" bundle:nil] forCellReuseIdentifier:@"IMPeopleList"];
    //[_resultTable registerNib:[UINib nibWithNibName:@"LDGroupListCell" bundle:nil] forCellReuseIdentifier:@"LDGroupListCell"];
    
    _resultTable.delegate=self;
    _resultTable.dataSource=self;
    _resultTable.showsVerticalScrollIndicator = NO;
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"检索中...", nil) maskType:SVProgressHUDMaskTypeClear];
    [[LDClient sharedInstance].contactListModel contactsWithKey:self.keyword onArea:search_area_inside forType:search_type_all completion:^(NSError *error, NSDictionary *info) {
        if (!error) {
            self.searchResultDict  = [[NSMutableDictionary alloc] initWithDictionary:info];
            [_resultTable reloadData];
        }
        [SVProgressHUD dismiss];
    }];
}

#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        NSArray *result = [self.searchResultDict objectForKey:@"users"];
        if (result && [result count] > 0) {
            return 20;
        }
        return 0.1;
    }else if(section == 1){
        NSArray *result = [self.searchResultDict objectForKey:@"groups"];
        if (result && [result count] >0) {
            return 20;
        }
        return 0.1;
    }else if(section == 2){
        NSArray *result = [self.searchResultDict objectForKey:@"robots"];
        if (result && [result count] >0) {
            return 20;
        }
        return 0.1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section{
    if (section  == 0 ) {
        NSArray *result = [self.searchResultDict objectForKey:@"users"];
        if (result && [result count] > 0) {
            UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
            customView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
            UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 150, 20)];
            labelTwo.backgroundColor = [UIColor clearColor];
            labelTwo.textAlignment = NSTextAlignmentLeft;
            labelTwo.textColor = [UIColor grayColor];
            [labelTwo setFont:[UIFont systemFontOfSize:14]];
            labelTwo.text = @"好友";
            [customView addSubview:labelTwo];
            return customView;
        }
    }else if (section == 1) {
        NSArray *result = [self.searchResultDict objectForKey:@"groups"];
        if (result && [result count] > 0) {
            UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
            customView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
            UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 150, 20)];
            labelTwo.backgroundColor = [UIColor clearColor];
            labelTwo.textAlignment = NSTextAlignmentLeft;
            labelTwo.textColor = [UIColor grayColor];
            [labelTwo setFont:[UIFont systemFontOfSize:14]];
            labelTwo.text = @"群组";
            [customView addSubview:labelTwo];
            return customView;
        }
    }else if (section == 2) {
        NSArray *result = [self.searchResultDict objectForKey:@"robots"];
        if (result && [result count] > 0) {
            UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
            customView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
            UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 150, 20)];
            labelTwo.backgroundColor = [UIColor clearColor];
            labelTwo.textAlignment = NSTextAlignmentLeft;
            labelTwo.textColor = [UIColor grayColor];
            [labelTwo setFont:[UIFont systemFontOfSize:14]];
            labelTwo.text = @"机器人";
            [customView addSubview:labelTwo];
            return customView;
        }
    }
    return  nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSArray *result = [self.searchResultDict objectForKey:@"users"];
        if (result && [result count] > 0) {
            return [result count];
        }
    }else if (section == 1) {
        NSArray *result = [self.searchResultDict objectForKey:@"groups"];
        if (result && [result count] > 0) {
            return [result count];
        }
    }else if (section == 2) {
        NSArray *result = [self.searchResultDict objectForKey:@"robots"];
        if (result && [result count] > 0) {
            return [result count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LDContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDContactListCell" forIndexPath:indexPath];
        LDUserModel * user = (LDUserModel *)[[self.searchResultDict objectForKey:@"users"]objectAtIndex:indexPath.row];
        [cell updateSearch:user];
        return cell;
    }else if(indexPath.section == 1){
        LDGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDGroupListCell" forIndexPath:indexPath];
        LDGroupModel * groupModel = (LDGroupModel *)[[self.searchResultDict objectForKey:@"groups"]objectAtIndex:indexPath.row];
        [cell bindSearchData:groupModel];
        return cell;
    }else if(indexPath.section == 2){
        LDContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDContactListCell" forIndexPath:indexPath];
        LDRobotModel * robot = (LDRobotModel *)[[self.searchResultDict objectForKey:@"robots"]objectAtIndex:indexPath.row];
        [cell updateRobot:robot];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LDUserModel *user = (LDUserModel *)[[self.searchResultDict objectForKey:@"users"]objectAtIndex:indexPath.row];
        if (user.ID == MYSELF.ID){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"myself" bundle:nil];
            LDInformationViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDInformationViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            LDContactInfoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDContactInfoViewController"];
            vc.userModel = user;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.section == 1){
        LDGroupModel * groupModel = (LDGroupModel *)[[self.searchResultDict objectForKey:@"groups"]objectAtIndex:indexPath.row];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        LDGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupViewController"];
        vc.groupModel = groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"searchToGroup"]) {
//        LDGroupModel *groupModel = (LDGroupModel*)sender;
//        LDGroupViewController *groupController = segue.destinationViewController;
//        groupController.groupModel = groupModel;
//    }else if ([segue.identifier isEqualToString:@"detailUser"]) {
//        LDContactModel *contactModel = (LDContactModel*)sender;
//        LDContactTableViewController *vc = segue.destinationViewController;
//        vc.contactModel = contactModel;
//        vc.sex = contactModel.sex;
//        vc.searchChoose = @"YES";
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
