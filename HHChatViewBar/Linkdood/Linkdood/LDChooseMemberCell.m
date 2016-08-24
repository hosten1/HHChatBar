//
//  LDAddBlacklistTableViewCell.m
//  Linkdood
//
//  Created by VRV2 on 16/5/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDChooseMemberCell.h"

@implementation LDChooseMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_addBlockAvara setCornerRadius:self.addBlockAvara.width*0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContact:(LDContactModel *)contact
{
    NSString *msgFrom = @"Unisex";
    if (contact.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (contact.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    [[LDClient sharedInstance] avatar:contact.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_addBlockAvara setImage:avatar];
    }];
    [_addBlockName setText:contact.name];
}

@end
