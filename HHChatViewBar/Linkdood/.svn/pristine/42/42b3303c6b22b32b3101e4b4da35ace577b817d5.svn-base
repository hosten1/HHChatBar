//
//  LDNearbyAddBuddyCollectionCell.m
//  Linkdood
//
//  Created by VRV2 on 16/8/8.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDNearbyAddBuddyCollectionCell.h"

@implementation LDNearbyAddBuddyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImageView *image = [[UIImageView alloc]init];
//    self.avarImage = ava;
    image.frame = CGRectMake(10, 10, 55, 55);
    [self.contentView addSubview:image];
    
    
}

-(void)setUserModelCell:(LDUserModel *)userModelCell{
    _userModelCell = userModelCell;
    if ([_userModelCell.avatar isEqualToString:@""]) {
        self.avarImage.image = [UIImage imageNamed:_userModelCell.sex == 1?@"MaleIcon":@"FemaleIcon"];
    }else{
        [[LDClient sharedInstance] avatar:_userModelCell.avatar withDefault:nil complete:^(UIImage *avatar) {
            [self.avarImage setImage:avatar];
        }];
    }
    if (_userModelCell.name == nil){
        self.avarImage.image = [UIImage imageNamed:@"menico"];
    }
    self.nameLable.text = self.userModelCell.name;
}
@end
