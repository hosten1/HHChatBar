//
//  LDChatRoomMessageCell.h
//  Linkdood
//
//  Created by VRV2 on 16/7/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
@class KYCuteView;

@interface LDChatRoomMessageCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *portrait;
@property (weak,nonatomic) IBOutlet UILabel *sender;
@property (weak,nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet MLLinkLabel *message;
@property (weak,nonatomic) IBOutlet UIButton *unread;
@property (weak,nonatomic) IBOutlet UIButton *isread;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unreadConstraint;
@property (assign,nonatomic) CGRect  rect;


@property (strong,nonatomic) LDChatModel *chatModel;
@property (strong,nonatomic) LDChatModel *searchChatModel;


/**
 *  自定义的 仿QQ小红点
 */
@property (strong,nonatomic) KYCuteView *cuteView;
@end
