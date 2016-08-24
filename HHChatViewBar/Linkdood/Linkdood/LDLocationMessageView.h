//
//  LDLocationMessageView.h
//  Linkdood
//
//  Created by VRV2 on 16/5/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface LDLocationMessageView : JSQMediaItem

/*!
 @property  latitude
 @descript  位置经度
 */
@property (assign,nonatomic) double latitude;

/*!
 @property  longitude
 @descript  位置纬度
 */
@property (assign,nonatomic) double longitude;

/*!
 @property  address
 @descript  位置对应的地名
 */
@property (strong,nonatomic) NSString *address;
@property (nonatomic, strong) LDLocationMessageModel  *LocationMessage;


- (instancetype)initWithMessage:(LDLocationMessageModel*)message;
@end
