//
//  LDTextMessageView.h
//  Linkdood
//
//  Created by renxin on 16/6/22.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
@protocol LDTextMessageViewDelegate <NSObject>
@optional
- (void)removeTextMessage:(LDTextMessageModel *)message;
- (void)textMessageViewDidResponserInstructMessage:(LDTextMessageModel*)testMessage;


@end
@interface LDTextMessageView : JSQMediaItem<JSQMessageMediaData, NSCoding, NSCopying>
@property (strong, nonatomic) UIImage *image;
@property (strong,nonatomic) LDTextMessageModel *message;
@property (strong,nonatomic) UILabel *lab;

- (instancetype)initWithMessage:(LDMessageModel*)message;
@property (nonatomic, weak) id <LDTextMessageViewDelegate> delegate;

@end
