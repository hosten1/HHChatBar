//
//  IMNew
//
//  Created by VRV on 15/8/11.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import "LDContactListCell.h"

@implementation LDContactListCell

- (void)updateContact:(LDGroupMemberModel *)member Value:(int)value
{
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    
    if ([member.avatar isEqualToString:@""]) {
        _avatar.image = [UIImage imageNamed:member.sex == 1?@"MaleIcon":@"FemaleIcon"];
    }else{
        [[LDClient sharedInstance] avatar:member.avatar withDefault:nil complete:^(UIImage *avatar) {
            [_avatar setImage:avatar];
        }];
    }
    if (member.name == nil) {
        _avatar.image = [UIImage imageNamed:@"menico"];
    }
    _name.font =[UIFont systemFontOfSize:16];
    _name.text = member.name;
    member = member;
}

- (void)updateSearch:(LDUserModel *)contact{
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    NSString *msgFrom = @"Unisex";
    if (contact.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (contact.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    [[LDClient sharedInstance] avatar:contact.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_avatar setImage:avatar];
    }];
    _name.text = contact.name;
    
    if (![contact.sign isKindOfClass:[NSNull class]]) {
        
    }
}

- (void)updateRobot:(LDRobotModel *)robot{
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    [[LDClient sharedInstance] avatar:robot.appIcon withDefault:@"AppIcon" complete:^(UIImage *avatar) {
        [_avatar setImage:avatar];
    }];
    _name.text = robot.appName;
}

- (void)updateGroupContact:(LDGroupMemberModel *)member Value:(int)value
{
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    if ([member.avatar isEqualToString:@""]) {
        NSString *msgFrom = @"Unisex";
        if (member.sex == msg_owner_male) {
            msgFrom = @"MaleIcon";
        }
        if (member.sex == msg_owner_female) {
            msgFrom = @"FemaleIcon";
        }
        _avatar.image = [UIImage imageNamed:msgFrom];
    }else{
        [[LDClient sharedInstance] avatar:member.avatar withDefault:nil complete:^(UIImage *avatar) {
            [_avatar setImage:avatar];
        }];
    }
    
    _name.font =[UIFont systemFontOfSize:16];
    _name.text = member.name;
    
    [[self.contentView viewWithTag:100] removeFromSuperview];
    
    if (member.userType == 3) {
        UIImageView *ownerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"group_owner"]];
        ownerImage.tag = 100;
        ownerImage.center = CGPointMake([_name contentSize].width + _name.frame.origin.x +30, _name.center.y);
        [self.contentView addSubview:ownerImage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
