//
//  LDGroupTransferViewController.h
//  Linkdood
//
//  Created by 王越 on 16/4/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJNIndexView/MJNIndexView.h>

@interface LDGroupTransferViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MJNIndexViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *groupMemberTable;
@property (strong, nonatomic) LDGroupModel *groupModel;
@property (strong,nonatomic) MJNIndexView *indexView;

@end
