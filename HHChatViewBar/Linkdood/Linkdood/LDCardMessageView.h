//
//  LDCardMessageView.h
//  Linkdood
//
//  Created by VRV2 on 16/5/20.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface LDCardMessageView : JSQMediaItem<JSQMessageMediaData, NSCoding, NSCopying>


@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *title;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic, copy) NSString *userName;
/**
 *  群，联系人，机器人
 */
@property (nonatomic,strong) LDItemModel *itemModel;
@property (nonatomic,strong) LDCardMessageModel *cardMessage;

- (instancetype)initWithMessage:(LDMessageModel*)message;
@end
