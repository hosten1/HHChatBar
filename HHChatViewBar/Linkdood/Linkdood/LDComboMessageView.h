//
//  LDComboMessageView.h
//  Linkdood
//
//  Created by yue on 7/8/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface LDComboMessageView : JSQMediaItem

@property(nonatomic,strong) LDComboMessageModel *combo;

- (instancetype)initWithMessage:(LDMessageModel*)message;

@end
