//
//  LDGroupCell.h
//  Linkdood
//
//  Created by 王越 on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (strong,nonatomic) LDGroupModel *group;

@end
