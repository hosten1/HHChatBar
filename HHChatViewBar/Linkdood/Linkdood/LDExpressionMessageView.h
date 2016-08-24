//
//  LDExpressionMessageView.h
//  Linkdood
//
//  Created by renxin on 16/6/21.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface LDExpressionMessageView : JSQPhotoMediaItem<JSQMessageMediaData, NSCoding, NSCopying>

@property (strong,nonatomic) LDExpressionMessageModel *message;

- (instancetype)initWithMessage:(LDMessageModel*)message;

@end
