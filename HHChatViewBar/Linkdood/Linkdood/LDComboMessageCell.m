//
//  LDComboMessageCell.m
//  Linkdood
//
//  Created by yue on 7/8/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDComboMessageCell.h"
@interface LDComboMessageCell(){
    NSDictionary *userInfo;
    LDMessageModel *messageModel;
}


@end

@implementation LDComboMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)bindData:(LDMessageModel *)msg userInfo:(NSDictionary *)info{
    messageModel = msg;
    userInfo = [info copy];
    if (messageModel.messageType == MESSAGE_TYPE_TEXT) {
        self.message.text = messageModel.message;
    }else
    self.message.text = [self messageByType];
    self.name.text = [self handelUserInfo];
    self.time.text = [[NSString stringWithFormat:@"%lld",messageModel.timestamp] specialTime:nil];
}



-(NSString *)messageByType{
    if (messageModel.messageType == MESSAGE_TYPE_IMAGE) {
        return @"[图片]";
    }else if (messageModel.messageType == MESSAGE_TYPE_AUDIO) {
        return @"[语音]";
    }else if (messageModel.messageType == MESSAGE_TYPE_LOCATION) {
        return @"[位置]";
    }else if (messageModel.messageType == MESSAGE_TYPE_CARD) {
        return @"[名片]";
    }else if (messageModel.messageType == MESSAGE_TYPE_EXPRESSTIONS) {
        return @"[动态表情]";
    }else if (messageModel.messageType == MESSAGE_TYPE_FILE) {
        return @"[文件]";
    }else if (messageModel.messageType == MESSAGE_TYPE_ASSEMBLE) {
        return @"[组合消息]";
    }
    else{
        return @"[暂未支持的消息类型]";
    }
}

-(NSString *)handelUserInfo{
    NSDictionary *dict = [userInfo objectForKey:[NSString stringWithFormat:@"%lld",messageModel.sendUserID]];
    
    return [dict objectForKey:@"name"];
}

@end
