//
//  IMNew
//
//  Created by VRV on 15/8/11.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDContactListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic) LDGroupMemberModel *member;

- (void)updateContact:(LDGroupMemberModel *)recent Value:(int)value;
- (void)updateSearch:(LDUserModel *)recent;
- (void)updateGroupContact:(LDGroupMemberModel *)recent Value:(int)value;
- (void)updateRobot:(LDRobotModel *)robot;

@end
