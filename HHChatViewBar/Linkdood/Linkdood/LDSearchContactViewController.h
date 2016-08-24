//
//  LegendAddBuddyController.h
//  IM
//
//  Created by liuxinbo on 14-8-14.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDSearchCell.h"


@interface LDSearchContactViewController : LDRootViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (strong, nonatomic) UITextField *keyword;

@end
