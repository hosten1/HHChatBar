//
//  IMNew
//
//  Created by VRV on 15/9/24.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHorizontalList.h"

@protocol LDCreateGroupViewControllerDelegate <NSObject>
@optional
- (void)createGroupSuccess:(int64_t)groupID;
- (void)addMemberSuccess;
@end

@interface LDCreateGroupViewController : LDRootViewController<UITableViewDataSource,UITableViewDelegate,ContactHorizontalListDelegate>{
}
@property (weak, nonatomic) IBOutlet UITableView *creatTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

//添加群成员
@property (nonatomic, assign) BOOL isAddGroupMember;
@property (nonatomic, assign) int64_t groupID;

@property (nonatomic, assign) id <LDCreateGroupViewControllerDelegate> delegate;
@end
