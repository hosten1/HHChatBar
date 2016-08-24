//
//  LDBlacklistCell.m
//  Linkdood
//
//  Created by VRV2 on 16/5/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDBlacklistCell.h"

@implementation LDBlacklistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_blacklistFriendAvatar setCornerRadius:self.blacklistFriendAvatar.width/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUserModel:(LDUserModel *)userModel{
    _userModel = userModel;
    NSString *msgFrom = @"Unisex";
    if (_userModel.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (_userModel.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    [[LDClient sharedInstance] avatar:_userModel.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_blacklistFriendAvatar setImage:avatar];
    }];
    [_blacklistFriendName setText:_userModel.name];
    
}
@end
