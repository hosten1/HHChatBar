//
//  IMNew
//
//  Created by VRV on 15/9/17.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDCreatGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *chooseAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) NSString  *chooseValue;
- (void)bindData:(LDContactModel *)recent;
@end
