//
//  LDContactCell.m
//  Linkdood
//
//  Created by xiong qing on 16/2/22.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDContactCell.h"

@implementation LDContactCell

- (void)awakeFromNib {
    [_portrait setCornerRadius:_portrait.width / 2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)canBecomeFirstResponder{
    return YES;
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
        [_portrait setImage:avatar];
    }];
    if (contact.remark.isEmpty) {
        [_nickname setText:contact.name];
    }else{
        [_nickname setText:contact.remark];
    }
    
    [_sign setText:contact.sign];
}

- (void)setUser:(LDUserModel *)user
{
    NSString *msgFrom = @"Unisex";
    if (user.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (user.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    [[LDClient sharedInstance] avatar:user.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_portrait setImage:avatar];
    }];
    [_nickname setText:user.name];
    [_sign setText:user.sign];
}

@end
