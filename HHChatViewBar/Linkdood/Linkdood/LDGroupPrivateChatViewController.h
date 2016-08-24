//
//  LDGroupPrivateChatViewController.h
//  Linkdood
//
//  Created by yue on 6/21/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHorizontalList.h"

@protocol LDGroupPrivateChatDelegate <NSObject>
@optional
- (void)selectSuccess:(NSArray *)members;
@end


@interface LDGroupPrivateChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ContactHorizontalListDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet UITableView *groupMemberTable;
@property (strong, nonatomic) LDGroupModel *groupModel;
@property (nonatomic, assign) bool isDirective;
@property (nonatomic, strong) id <LDGroupPrivateChatDelegate> delegate;

@end
