//
//  LDImageMessage.m
//  Linkdood
//
//  Created by xiong qing on 16/3/17.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDImageMessageView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface LDImageMessageView()

@property (strong, nonatomic) UIImageView *cachedImageView;
@end

@implementation LDImageMessageView

- (instancetype)initWithMessage:(LDMessageModel*)message
{
    if (self = [super init]) {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        self.message = (LDImageMessageModel*)message;
    }
    return self;
}

-(UIView *)mediaView
{
    CGSize size = [self mediaViewDisplaySize];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImage:[UIImage imageNamed:@"DefaultImage"]];
    imageView.clipsToBounds = YES;
    self.cachedImageView = imageView;
    
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    if (self.appliesMediaViewMaskAsOutgoing) {
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyOutgoingBubbleImageMaskToMediaView:self.cachedImageView];
    }else{
        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyIncomingBubbleImageMaskToMediaView:self.cachedImageView];
    }
    [_message loadThumbnailImage:^(id file) {
        if (_message.activeType == 1) {
            [self burnMessage:file];
        }else{
            [self.cachedImageView setImage:file];
        }
    } onProgress:nil];
    return self.cachedImageView;
}

-(void)backTime:(NSTimer *)timer{
    long time = [[[timer userInfo]objectForKey:@"time"] integerValue];
    if (time < 1) {
        [self.lab setFrame:CGRectMake(0, 0, self.cachedImageView.frame.size.width, self.cachedImageView.frame.size.height)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeMessage:)]) {
            [self.delegate removeMessage:_message];
        }
        [timer invalidate];

    }else{
        [UIView animateWithDuration:time animations:^{
            [self.lab setFrame:CGRectMake(0, 0, self.cachedImageView.frame.size.width, self.cachedImageView.frame.size.height)];
        } completion:^(BOOL finished) {
            
        }];
        time = time-1;
        NSString *timea = [NSString stringWithFormat:@"%ld",time];
        [[timer userInfo] setValue:timea forKey:@"time"];
    }
}

- (void)burnMessage:(id)file{
    NSString *time;
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, self.cachedImageView.frame.size.height)];
    self.lab.backgroundColor = [UIColor redColor];
    self.lab.alpha = 0.1;
    [_cachedImageView addSubview:self.lab];
    [self.cachedImageView setImage:file];
    [self.cachedImageView addSubview:self.lab];
    NSString *str = [NSString stringWithFormat:@"%lld",_message.timestamp];
    NSString * timeStampString = str;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *sendTime = [objDateformat stringFromDate: date];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *mmSendTime = [sendTime substringWithRange:NSMakeRange(14,2)];
    NSString *mmDateString = [dateString substringWithRange:NSMakeRange(14,2)];
    if ([mmSendTime isEqualToString:mmDateString]) {
        NSString *ssSendTime = [sendTime substringWithRange:NSMakeRange(17,2)];
        NSString *ssDateString = [dateString substringWithRange:NSMakeRange(17,2)];
        int sendTimess = [ssSendTime intValue];
        int dataStringss = [ssDateString intValue];
        time = dataStringss-sendTimess>10?@"0":[NSString stringWithFormat:@"%d",sendTimess-dataStringss +10];
    }else{
        NSString *ssSendTime = [sendTime substringWithRange:NSMakeRange(17,2)];
        NSString *ssDateString = [dateString substringWithRange:NSMakeRange(18,2)];
        int sendTimess = [ssSendTime intValue];
        int dataStringss = [ssDateString intValue]+60;
        time = dataStringss - sendTimess >10?@"0":[NSString stringWithFormat:@"%d",sendTimess-dataStringss +10];
    }
    [self.lab setFrame:CGRectMake(0, 0, (self.cachedImageView.frame.size.width)*(10-[time intValue])/10, self.cachedImageView.frame.size.height)];
    NSTimer *timer;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:time,@"time", nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(backTime:) userInfo:dic repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
}

-(CGSize)mediaViewDisplaySize
{
    CGSize size = CGSizeMake(90, 160);
    CGSize orgSize = CGSizeMake(_message.width, _message.height);
    CGFloat scale = fmin(orgSize.width / size.width,orgSize.height / size.height);
    return CGSizeMake(orgSize.width / scale, orgSize.height / scale);
}

@end
