//
//  LDRoomMessageCell.h
//  Linkdood
//
//  Created by VRV2 on 16/7/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDRoomMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLable;
@property (weak, nonatomic) IBOutlet UILabel *roomNumberNumber;

@property (strong,nonatomic) LDRoomModel *roomModel ;
@end
