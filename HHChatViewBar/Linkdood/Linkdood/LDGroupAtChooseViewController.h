//
//  LDGroupAtChooseViewController.h
//  Linkdood
//
//  Created by yue on 16/6/20.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJNIndexView/MJNIndexView.h>

typedef void (^MemberChoosen)(int64_t memberID);

@interface LDGroupAtChooseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MJNIndexViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *groupMemberTable;
@property (strong, nonatomic) LDGroupModel *groupModel;
@property (strong,nonatomic) MJNIndexView *indexView;
@property (strong,nonatomic) MemberChoosen memberChoosen;

@end
