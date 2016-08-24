//
//  LDTaskViewController.h
//  Linkdood
//
//  Created by yue on 8/18/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TASK_TYPE_RECEIVE = 0,
    TASK_TYPE_SEND = 1,
    TASK_TYPE_HISTORY = 2,
}TASK_TYPE;

@interface LDTaskViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) TASK_TYPE type;
@end
