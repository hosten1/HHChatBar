//
//  LDRobotListViewController.h
//  Linkdood
//
//  Created by 王越 on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJNIndexView/MJNIndexView.h>

typedef void(^backContact)(LDItemModel* item);
typedef void(^qrCode)(LDItemModel* item);
@interface LDRobotListViewController : UITableViewController

@property (strong,nonatomic) MJNIndexView *indexView;
@property (assign,nonatomic) BOOL FromPushWithSelectCard;
@property (copy,nonatomic) backContact backContactBlock;
@property (copy,nonatomic) qrCode qrCodeBlock;


@end
