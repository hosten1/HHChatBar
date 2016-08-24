//
//  LDEmptyMessageView.m
//  Linkdood
//
//  Created by VRV2 on 16/7/11.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDEmptyMessageView.h"

@implementation LDEmptyMessageView
- (instancetype)initWithMessage:(LDMessageModel *)message{
    self = [super init];
    if (self)
    {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        
        self.Message = message;
    }
    return self;
}
-(CGSize)mediaViewDisplaySize{
    return CGSizeMake(0.01, 0.01);
}
-(UIView *)mediaView{
    UIImageView *cachedImageView = [[UIImageView alloc]init];
    CGSize size = [self mediaViewDisplaySize];
    cachedImageView.frame = CGRectMake(0, 0, size.width, size.height);
    
//    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
//    if (self.appliesMediaViewMaskAsOutgoing) {
//        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
//        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyOutgoingBubbleImageMaskToMediaView:cachedImageView];
//    }else{
//        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
//        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyIncomingBubbleImageMaskToMediaView:cachedImageView];
//    }
    return cachedImageView;
}

@end
