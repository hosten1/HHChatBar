//
//  LDComboMessageView.m
//  Linkdood
//
//  Created by yue on 7/8/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDComboMessageView.h"

@implementation LDComboMessageView

- (instancetype)initWithMessage:(LDMessageModel *)message{
    self = [super init];
    if (self)
    {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        self.combo = (LDComboMessageModel *)message;
    }
    return self;
}

-(CGSize)mediaViewDisplaySize
{
    return CGSizeMake(178,80);
}

-(UIView *)mediaView
{
    UIImageView *mediaView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,self.mediaViewDisplaySize.width,self.mediaViewDisplaySize.height}];
    if (self.combo.messages.count >=1){
        
        
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:(CGRect){20,11,150,17}];
        [firstLabel setFont:[UIFont systemFontOfSize:12]];
        [firstLabel setTextColor:[UIColor blackColor]];
        
        LDMessageModel *firstMessage = [self.combo.messages objectAtIndex:0];
        if (firstMessage.messageType == MESSAGE_TYPE_TEXT){
            [firstLabel setText:[NSString stringWithFormat:@"%@:%@",[self handelUserInfo:firstMessage],firstMessage.message]];
        }else{
            [firstLabel setText:[NSString stringWithFormat:@"%@:%@",[self handelUserInfo:firstMessage],[self messageByType:firstMessage.messageType]]];
        }
        
        [mediaView addSubview:firstLabel];
    }
    
    if(self.combo.messages.count>=2){
        UILabel *secondLabel = [[UILabel alloc]initWithFrame:(CGRect){20,31,150,17}];
        [secondLabel setFont:[UIFont systemFontOfSize:12]];
        [secondLabel setTextColor:[UIColor blackColor]];
        LDMessageModel *secondMessage = [self.combo.messages objectAtIndex:1];
        if (secondMessage.messageType == MESSAGE_TYPE_TEXT){
            [secondLabel setText:[NSString stringWithFormat:@"%@:%@",[self handelUserInfo:secondMessage],secondMessage.message]];
        }else{
            [secondLabel setText:[NSString stringWithFormat:@"%@:%@",[self handelUserInfo:secondMessage],[self messageByType:secondMessage.messageType]]];
        }
        [mediaView addSubview:secondLabel];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){0,55,178,1}];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:(CGRect){7,58,160,17}];
    [thirdLabel setFont:[UIFont systemFontOfSize:12]];
    [thirdLabel setTextColor:[UIColor blackColor]];
    [thirdLabel setText:@"点击查看更多"];
    [thirdLabel setTextAlignment:NSTextAlignmentRight];
    
    [mediaView addSubview:thirdLabel];
    [mediaView addSubview:lineView];
    
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    if (self.appliesMediaViewMaskAsOutgoing) {
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyOutgoingBubbleImageMaskToMediaView:mediaView];
    }else{
        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyIncomingBubbleImageMaskToMediaView:mediaView];
    }
    
    mediaView.backgroundColor = self.appliesMediaViewMaskAsOutgoing?[UIColor jsq_messageBubbleLightGrayColor]:[UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    [mediaView setClipsToBounds:YES];
    
    return mediaView;
    
}

-(NSString *)messageByType:(int16_t)type{
    if (type == MESSAGE_TYPE_IMAGE) {
        return @"[图片]";
    }else if (type == MESSAGE_TYPE_AUDIO) {
        return @"[语音]";
    }else if (type == MESSAGE_TYPE_LOCATION) {
        return @"[位置]";
    }else if (type == MESSAGE_TYPE_CARD) {
        return @"[名片]";
    }else if (type == MESSAGE_TYPE_EXPRESSTIONS) {
        return @"[动态表情]";
    }else if (type == MESSAGE_TYPE_FILE) {
        return @"[文件]";
    }else if (type == MESSAGE_TYPE_ASSEMBLE) {
        return @"[组合消息]";
    }
    else{
        return @"[暂未支持的消息类型]";
    }
}

-(NSString *)handelUserInfo:(LDMessageModel *)msg{
    NSDictionary *dict = [self.combo.userInfo objectForKey:[NSString stringWithFormat:@"%lld",msg.sendUserID]];
    
    return [dict objectForKey:@"name"];
}

@end
