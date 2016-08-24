//
//  LDBlacklistCell.h
//  Linkdood
//
//  Created by VRV2 on 16/5/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@interface LDBlacklistCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *blacklistFriendAvatar;
@property (weak, nonatomic) IBOutlet UILabel *blacklistFriendName;

@property (strong,nonatomic) LDUserModel *userModel;
@end
