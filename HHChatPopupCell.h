//
//  HHChatPopupCell.h
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "modelTemp.h"
@interface HHChatPopupCell : UITableViewCell
+(instancetype)loadTableCell:(UITableView*)tableView idResu:(NSString*)cellid;

@property (strong,nonatomic)modelTemp *mode ;
@end
