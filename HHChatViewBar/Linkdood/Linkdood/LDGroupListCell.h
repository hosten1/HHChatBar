//
//  IMNew
//
//  Created by VRV on 15/9/17.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDGroupListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
- (void)bindData:(LDGroupModel *)recent;
- (void)bindSearchData:(LDGroupModel *)recent;
@end
