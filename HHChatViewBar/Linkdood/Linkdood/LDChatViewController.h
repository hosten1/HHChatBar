//
//  LDChatViewController.h
//  Linkdood
//
//  Created by xiong qing on 16/2/24.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface LDChatViewController : JSQMessagesViewController

@property (strong,nonatomic) LDChatModel *chatModel;
@property (strong,nonatomic) NSMutableArray *imageMessages;
@property (strong,nonatomic) NSIndexPath *scrollIndexPath;
@property (assign,nonatomic) bool hiddenStatusBar;
@property (assign,nonatomic) LDContactModel *contact;
@property (assign,nonatomic) bool isFire;
@property (assign,nonatomic) bool isDirective;
@property (assign,nonatomic) bool isReceipt;
@property (assign,nonatomic) bool isDelayMsg;
@property (assign,nonatomic) bool isTask;

- (instancetype)initWithChat:(LDChatModel*)chat;
- (instancetype)initWithTarget:(int64_t)target;
- (void)didPressExtend:(NSInteger)index;
- (void)receivedMessage:(LDMessageModel*)message;

-(void)handleDirectiveHistoryMessage;
-(void)handleDirectiveMessage:(LDMessageModel*)message;
@end
