//
//  LDGroupPrivateChatCell.m
//  Linkdood
//
//  Created by yue on 6/21/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDGroupPrivateChatCell.h"

@implementation LDGroupPrivateChatCell

- (void)bindData:(LDGroupMemberModel *)member{
    LDGroupMemberListModel *groupMembers = (LDGroupMemberListModel*)[[LDClient sharedInstance] groupMembers];
    if ([groupMembers.selectedItems containsLDItem:member]) {
        _chooseAvatar.image = [UIImage imageNamed:@"CellBlueSelected.png"];
    }else if ([groupMembers.defaultSelectedItems containsObject:member]) {
        _chooseAvatar.image = [UIImage imageNamed:@"CellGraySelected.png"];
    }else{
        _chooseAvatar.image = [UIImage imageNamed:@"CellNotSelected.png"];
    }
    
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    
    _name.text = member.name;
    
    NSString *msgFrom = @"Unisex";
    if (member.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (member.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    [[LDClient sharedInstance] avatar:member.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_avatar setImage:avatar];
    }];
}


@end
