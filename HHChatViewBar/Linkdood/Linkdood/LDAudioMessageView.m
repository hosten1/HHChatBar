//
//  LDAudioMessageView.m
//  Linkdood
//
//  Created by xiong qing on 16/3/17.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDAudioMessageView.h"

@interface LDAudioMessageView()

@property (strong, nonatomic) UIImageView *audioView;

@end

@implementation LDAudioMessageView

- (instancetype)initWithMessage:(LDMessageModel*)message
{
    if (self = [super init]) {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        self.message = (LDAudioMessageModel*)message;
    }
    return self;
}

-(UIView *)mediaView
{
    CGSize size = [self mediaViewDisplaySize];
    
    self.audioView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,size}];
    [self.audioView setUserInteractionEnabled:YES];
    
    if (_message.sendUserID == MYSELF.ID) {
        [self.audioView setImage:[[UIImage imageNamed:@"AudioOutgoing"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 25) resizingMode:UIImageResizingModeTile]];
    }else{
        [self.audioView setImage:[[UIImage imageNamed:@"AudioIncoming"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 20) resizingMode:UIImageResizingModeTile]];
    }
    return self.audioView;
}

-(CGSize)mediaViewDisplaySize
{
    return CGSizeMake(150, 40);
}

@end
