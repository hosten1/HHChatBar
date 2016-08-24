//
//  LDNoteCell.h
//  Linkdood
//
//  Created by VRV2 on 16/8/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface LDNoteCell : JSQMediaItem
@property (strong,nonatomic) LDNoteModel *noteModel;
- (instancetype)initWithMessage:(LDNoteModel *)noteModel;
@end
