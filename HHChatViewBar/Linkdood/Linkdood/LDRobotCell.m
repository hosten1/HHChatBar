//
//  LDRobotCell.m
//  Linkdood
//
//  Created by 王越 on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDRobotCell.h"

@implementation LDRobotCell

- (void)awakeFromNib {
    [_portrait setCornerRadius:_portrait.width / 2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setRobot:(LDRobotModel *)robot
{
    [[LDClient sharedInstance] avatar:robot.appIcon withDefault:@"robot" complete:^(UIImage *avatar) {
        [_portrait setImage:avatar];
    }];
    [_robotName setText:robot.appName];
}

@end
