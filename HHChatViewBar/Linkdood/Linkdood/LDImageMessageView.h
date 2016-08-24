//
//  LDImageMessage.h
//  Linkdood
//
//  Created by xiong qing on 16/3/17.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

@protocol LDImageMessageViewDelegate <NSObject>
@optional
- (void)removeMessage:(LDImageMessageModel *)message;



@end
@interface LDImageMessageView : JSQPhotoMediaItem<JSQMessageMediaData, NSCoding, NSCopying>

@property (strong,nonatomic) LDImageMessageModel *message;
@property (strong,nonatomic) UILabel *lab;
- (instancetype)initWithMessage:(LDMessageModel*)message;
@property (nonatomic, weak) id <LDImageMessageViewDelegate> delegate;


@end
