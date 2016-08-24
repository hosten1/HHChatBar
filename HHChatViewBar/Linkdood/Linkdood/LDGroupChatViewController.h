//
//  LDGroupChatViewController.h
//  Linkdood
//
//  Created by xiong qing on 16/2/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDChatViewController.h"

@interface LDGroupChatViewController : LDChatViewController<UITextViewDelegate>

@property (strong,nonatomic) LDGroupModel *group;

@end
