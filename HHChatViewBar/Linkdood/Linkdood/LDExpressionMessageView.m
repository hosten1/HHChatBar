//
//  LDExpressionMessageView.m
//  Linkdood
//
//  Created by renxin on 16/6/21.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDExpressionMessageView.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
@interface LDExpressionMessageView()
@property (strong, nonatomic) UIImageView *cachedImageView;

@end

@implementation LDExpressionMessageView
- (instancetype)initWithMessage:(LDMessageModel*)message
{
    if (self = [super init]) {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        self.message = (LDExpressionMessageModel*)message;
        
    }
    return self;
}

-(UIView *)mediaView
{
    CGSize size = [self mediaViewDisplaySize];
    YLImageView *imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = [YLGIFImage imageNamed:[NSString stringWithFormat:@"%@",self.message.message]];
    self.cachedImageView = imageView;
    return self.cachedImageView;
}

-(CGSize)mediaViewDisplaySize
{
    CGSize size = CGSizeMake(120, 120);
    CGSize orgSize = CGSizeMake(120, 120);
    CGFloat scale = fmin(orgSize.width / size.width,orgSize.height / size.height);
    return CGSizeMake(orgSize.width / scale, orgSize.height / scale);
}
@end
