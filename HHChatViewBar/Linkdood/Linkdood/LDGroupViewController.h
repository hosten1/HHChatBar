//
//  LDContactGroupInfoView.h
//  Linkdood
//
//  Created by VRV on 15/12/10.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDGroupViewController : LDRootTableViewController<UITableViewDataSource,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *memeberCount;
@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (weak, nonatomic) IBOutlet UILabel *fileCount;
@property (strong, nonatomic) LDGroupModel *groupModel;
@end
