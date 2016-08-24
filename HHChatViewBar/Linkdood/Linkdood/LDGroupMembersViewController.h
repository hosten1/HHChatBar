//
//  LDGroupMembersViewController.h
//  Linkdood
//
//  Created by VRV on 15/12/11.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJNIndexView/MJNIndexView.h>
#import "LDCreateGroupViewController.h"

@interface LDGroupMembersViewController : LDRootViewController<LDCreateGroupViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,MJNIndexViewDataSource/*,LDModelDelegate,LDGroupModelDelegate*/>

@property (weak, nonatomic) IBOutlet UITableView *groupMemberTable;
@property (strong, nonatomic) LDGroupModel *groupModel;
@property (strong,nonatomic) MJNIndexView *indexView;

@end
