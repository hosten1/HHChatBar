//
//  LDAddBlacklistTableViewController.h
//  Linkdood
//
//  Created by VRV2 on 16/5/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backContact)(LDItemModel* item);
typedef void(^qrCode)(LDItemModel* item);

@interface LDChooseMemberController : UITableViewController
/**
 *  0:代表加入黑名单操作，1，代表选择联系人操作
 */
@property (assign,nonatomic) NSInteger type;
@property (copy,nonatomic) backContact backContactBlock;
@property (copy,nonatomic) qrCode qrCodeBlock;

@end
