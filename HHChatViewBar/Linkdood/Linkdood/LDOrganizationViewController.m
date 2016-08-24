//
//  LDOrganizationViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/5/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDOrganizationViewController.h"
#import "LDOrganizationCell.h"
@interface LDOrganizationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *organizationTableView;

@end

@implementation LDOrganizationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_contents numberOfRowsInSection:section];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_contents numberOfSections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDOrganizationCell"];
    
    LDItemModel *model= [_contents itemAtIndexPath:indexPath];
    if ([[_contents itemAtIndexPath:indexPath] isKindOfClass:[LDOrganizationModel class]]) {
        LDOrganizationModel *org = (LDOrganizationModel *)model;
        [cell initCellOrg:org];
    }else{
        LDEntpriseUserModel *user = (LDEntpriseUserModel *)model;
        [cell initCellUser:user];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDOrganizationContentsListModel *contents = [[LDOrganizationContentsListModel alloc]init];
    
    if ([[_contents itemAtIndexPath:indexPath] isKindOfClass:[LDOrganizationModel class]]) {
        LDOrganizationModel *org = (LDOrganizationModel*)[_contents itemAtIndexPath:indexPath];
        [contents queryOrganizationContents:org completion:^(NSError *error) {
            if(!error){
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
                LDOrganizationViewController *orgVC = [sb instantiateViewControllerWithIdentifier:@"LDOrganizationViewController"];
                orgVC.contents = contents;
                [self.navigationController pushViewController:orgVC animated:YES];
            }
        }];
    }
}
@end
