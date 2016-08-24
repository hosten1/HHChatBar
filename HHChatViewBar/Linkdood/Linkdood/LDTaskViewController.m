//
//  LDTaskViewController.m
//  Linkdood
//
//  Created by yue on 8/18/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDTaskViewController.h"

@interface LDTaskViewController(){
    LDTaskMessageListModel *taskList;
}

@end

@implementation LDTaskViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"任务";
    
    self.type = TASK_TYPE_RECEIVE;
    taskList = [[LDTaskMessageListModel alloc]init];
    [taskList queryReceiveMessages:^(NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        }
    }];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"task"];
    LDTaskMessageModel *task = [[taskList allItems] objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%lld",task.sendUserID]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [taskList allItems].count;
}
- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl *segmented = sender;
    self.type = (TASK_TYPE)segmented.selectedSegmentIndex;
    
    switch (self.type) {
        case TASK_TYPE_RECEIVE:
        {
            [taskList queryReceiveMessages:^(NSError *error) {
                if (!error) {
                    [self.tableView reloadData];
                }
            }];
        }
            break;
        case TASK_TYPE_SEND:
        {
            [taskList querySendMessages:^(NSError *error) {
                if (!error) {
                    [self.tableView reloadData];
                }
            }];
        }
            break;
        case TASK_TYPE_HISTORY:
        {
            [taskList queryHistoryMessages:^(NSError *error) {
                if (!error) {
                    [self.tableView reloadData];
                }
            }];
        }
            break;
    }
}

@end
