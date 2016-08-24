//
//  LDGroupCell.m
//  Linkdood
//
//  Created by 王越 on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDGroupCell.h"

@implementation LDGroupCell

- (void)awakeFromNib {
    [_portrait setCornerRadius:_portrait.width / 2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setGroup:(LDGroupModel *)group
{
    [[LDClient sharedInstance] avatar:group.avatarUrl withDefault:@"GroupIcon" complete:^(UIImage *avatar) {
        [_portrait setImage:avatar];
    }];
    [_groupName setText:group.groupName];
}
@end
