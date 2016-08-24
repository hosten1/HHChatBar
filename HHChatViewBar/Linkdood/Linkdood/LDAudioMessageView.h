//
//  LDAudioMessageView.h
//  Linkdood
//
//  Created by xiong qing on 16/3/17.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface LDAudioMessageView : JSQVideoMediaItem<JSQMessageMediaData, NSCoding, NSCopying>

@property (strong,nonatomic) LDAudioMessageModel *message;

- (instancetype)initWithMessage:(LDMessageModel*)message;

@end
