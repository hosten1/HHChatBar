//
//  IMNew
//
//  Created by VRV on 15/9/17.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import "LDGroupListCell.h"

@implementation LDGroupListCell


- (void)bindSearchData:(LDGroupModel *)recent{
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    _name.text = recent.groupName;
    
    [[LDClient sharedInstance] avatar:recent.avatarUrl withDefault:@"GroupIcon" complete:^(UIImage *avatar) {
        [_avatar setImage:avatar];
    }];
}

- (void)bindData:(LDGroupModel *)recent{
    NSLog(@"%lld",recent.ID);
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    _name.text = recent.groupName;
    
    [[LDClient sharedInstance] avatar:recent.avatarUrl withDefault:@"GroupIcon" complete:^(UIImage *avatar) {
        [_avatar setImage:avatar];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
