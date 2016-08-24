//
//  LDAddBlacklistTableViewCell.h
//  Linkdood
//
//  Created by VRV2 on 16/5/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDChooseMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addBlockAvara;
@property (weak, nonatomic) IBOutlet UILabel *addBlockName;
@property (strong,nonatomic) LDContactModel *contact;
@end
