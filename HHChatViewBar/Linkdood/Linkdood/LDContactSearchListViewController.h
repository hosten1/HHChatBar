//
//  IMNew
//
//  Created by VRV on 15/9/17.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDContactSearchListViewController : LDRootViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *resultTable;
@property (strong, nonatomic) NSString *keyword;
@property (assign, nonatomic) BOOL personDetail;

@end
