//
//  LDGroupPrivateChatCell.h
//  Linkdood
//
//  Created by yue on 6/21/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDGroupPrivateChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *chooseAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) NSString  *chooseValue;

- (void)bindData:(LDGroupMemberModel *)recent;

@end
