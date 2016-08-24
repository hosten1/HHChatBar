//
//  LDContactInfoViewController.h
//  Linkdood
//
//  Created by xiong qing on 16/3/11.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDContactInfoViewController : LDRootTableViewController

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (strong,nonatomic) LDContactModel *contactModel;
@property (assign,nonatomic) int64_t userInfoIDForomChatCard;
@property (strong,nonatomic) LDUserModel *userModel;
@property (assign,nonatomic) BOOL pushFromChat;
@property (assign,nonatomic) BOOL pushFromChatCard;
@end
