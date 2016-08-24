//
//  LDOrganizationCell.m
//  Linkdood
//
//  Created by renxin-.- on 16/5/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDOrganizationCell.h"

@interface LDOrganizationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *organizationImage;
@property (weak, nonatomic) IBOutlet UILabel *organizationName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dutyInfo;
@property (weak, nonatomic) IBOutlet UILabel *orgNumLab;
@property (weak, nonatomic) IBOutlet UILabel *personNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *orgBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *perBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *orgImage;
@property (weak, nonatomic) IBOutlet UIImageView *personImage;

@end

@implementation LDOrganizationCell
- (void)initCellOrg:(LDOrganizationModel *)org
{
    [_orgBgImage setHidden:NO];
    [_perBgImage setHidden:NO];
    [_orgImage setHidden:NO];
    [_personImage setHidden:NO];
    [_organizationName setHidden:NO];
    [_userName setHidden:YES];
    [_dutyInfo setHidden:YES];
    [_orgNumLab setHidden:NO];
    [_personNumLab setHidden:NO];
    self.organizationName.text = org.orgName;
    [self.organizationImage setImage:[UIImage imageNamed:@"org_nomal"]];
    _orgNumLab.text = [NSString stringWithFormat:@"%lld",org.subOrgNum];
    _personNumLab.text = [NSString stringWithFormat:@"%lld",org.subUserNum];
}
- (void)initCellUser:(LDEntpriseUserModel *)user
{
    [_orgBgImage setHidden:YES];
    [_perBgImage setHidden:YES];
    [_orgImage setHidden:YES];
    [_personImage setHidden:YES];
    [_organizationName setHidden:YES];
    [_userName setHidden:NO];
    [_dutyInfo setHidden:NO];
    [_orgNumLab setHidden:YES];
    [_personNumLab setHidden:YES];
    self.userName.text = user.enName;
    self.dutyInfo.text = user.duty;
    LDUserModel *userModel = [[LDUserModel alloc] initWithID:user.ID];
    NSString *msgFrom = @"Unisex";
    [[LDClient sharedInstance] avatar:userModel.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_organizationImage setImage:avatar];
    }];
}
@end
