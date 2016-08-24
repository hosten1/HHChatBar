//
//  LDNoteListTableViewController.h
//  Linkdood
//
//  Created by VRV2 on 16/8/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

typedef void(^alertValueBack)(NSString *title,NSString *keyWorld);

@interface LDNoteListTableViewController : JSQMessagesViewController
@property (copy,nonatomic) alertValueBack alertCallBack;
@property (strong,nonatomic) LDNoteModel *noteModel;
@property (strong,nonatomic) NSMutableArray *imageMessages;
@property (strong,nonatomic) NSIndexPath *scrollIndexPath;
@property (assign,nonatomic) bool hiddenStatusBar;
@property (strong,nonatomic) LDNoteListModel *noteList;
@property(assign,nonatomic)int64_t originId;

@property (assign,nonatomic) bool isFire;
- (instancetype)initWithSenderTarget:(int64_t)sendTarget;
@end
