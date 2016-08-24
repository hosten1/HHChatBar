//
//  IMNew
//
//  Created by VRV on 15/9/17.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import "LDCreatGroupCell.h"

@implementation LDCreatGroupCell

- (void)bindData:(LDContactModel *)contact{
    LDContactListModel *contactList = (LDContactListModel*)[[LDClient sharedInstance] contactListModel];
    if ([contactList.selectedItems containsObject:contact]) {
        _chooseAvatar.image = [UIImage imageNamed:@"CellBlueSelected.png"];
    }else if ([contactList.defaultSelectedItems containsObject:contact]) {
        _chooseAvatar.image = [UIImage imageNamed:@"CellGraySelected.png"];
    }else{
        _chooseAvatar.image = [UIImage imageNamed:@"CellNotSelected.png"];
    }
   
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;

    NSString *msgFrom = @"Unisex";
    if (contact.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (contact.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    _name.text = contact.name;
    [[LDClient sharedInstance] avatar:contact.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_avatar setImage:avatar];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
