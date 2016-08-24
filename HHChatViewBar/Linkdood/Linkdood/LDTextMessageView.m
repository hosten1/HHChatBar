//
//  LDTextMessageView.m
//  Linkdood
//
//  Created by renxin on 16/6/22.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDTextMessageView.h"
#import "NSString+MLExpression.h"
#import "MLLinkLabel.h"
#define MAXFLOAT    0x1.fffffep+127f
@interface LDTextMessageView ()
{
    MLExpression *exp;
    MLLinkLabel *messageLabel;
}
@property (strong, nonatomic) UIImageView *cachedImageView;

@end
@implementation LDTextMessageView

- (instancetype)initWithMessage:(LDMessageModel *)message{
    self = [super init];
    if (self)
    {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        self.message = (LDTextMessageModel*)message;
    }
    return self;
}

-(CGSize)mediaViewDisplaySize{
    CGSize contantSize = CGSizeZero;
    messageLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(0, 0, 180, MAXFLOAT)];
    if ([_message.message rangeOfString:DirectiveShake].location != NSNotFound) {//如果是抖一抖消息
        NSString *keyString = [NSString stringWithFormat:@"key_%lld",_message.ID];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        if(![userDef boolForKey:keyString]){
            UIView *winView = [UIApplication sharedApplication].keyWindow;
            [self shakeAnimationForView:winView];

        };
        NSString *text = [_message.message stringByReplacingOccurrencesOfString:DirectiveShake withString:@""];
        messageLabel.attributedText = [[NSString stringWithFormat:@"%@ [抖一抖]",text] expressionAttributedStringWithExpression:[self getMLExpression]];
    }else if ([_message.message rangeOfString:DirectivedelDelAll].location != NSNotFound){
        NSString *text = [_message.message stringByReplacingOccurrencesOfString:DirectivedelDelAll withString:@""];
        messageLabel.attributedText = [[NSString stringWithFormat:@"%@ [橡皮擦]",text] expressionAttributedStringWithExpression:[self getMLExpression]];
        
    }else if ([_message.message rangeOfString:DirectivedelDelToday].location != NSNotFound){
        NSString *text = [_message.message stringByReplacingOccurrencesOfString:DirectivedelDelToday withString:@""];
        messageLabel.attributedText = [[NSString stringWithFormat:@"%@ [橡皮擦]",text] expressionAttributedStringWithExpression:[self getMLExpression]];
    }
    else{
        messageLabel.attributedText = [self.message.message expressionAttributedStringWithExpression:[self getMLExpression]];
    }
    
    messageLabel.numberOfLines = 0;
    messageLabel.allowLineBreakInsideLinks = NO;
    messageLabel.linkTextAttributes = nil;
    messageLabel.activeLinkTextAttributes = nil;
    [messageLabel sizeToFit];
    contantSize = [messageLabel size];
    CGSize size;
    size.width = contantSize.width+25;
    size.height = contantSize.height+20;
    return size;
}
-(UIView *)mediaView{
    
    _cachedImageView = [[UIImageView alloc]init];
    CGSize size = [self mediaViewDisplaySize];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self.message.limitRange.count >0) {
        imageView.backgroundColor = [UIColor colorWithRed:245/255.0 green:191/255.0 blue:79/255.0 alpha:1];
    }
    else{
        imageView.backgroundColor = self.appliesMediaViewMaskAsOutgoing?[UIColor jsq_messageBubbleLightGrayColor]:[UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    }
    imageView.clipsToBounds = YES;
    
    [imageView addSubview:messageLabel];
    messageLabel.center = CGPointMake(imageView.bounds.size.width/2,imageView.bounds.size.height/2);    
    self.cachedImageView = imageView;
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    if (self.appliesMediaViewMaskAsOutgoing) {
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyOutgoingBubbleImageMaskToMediaView:self.cachedImageView];
    }else{
        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyIncomingBubbleImageMaskToMediaView:self.cachedImageView];
    }
    if (_message.activeType == 1) {
        [self burnMessage];
    }
    return self.cachedImageView;
}

-(void)backTime:(NSTimer *)timer{
    long time = [[[timer userInfo]objectForKey:@"time"] integerValue];
    if (time < 1) {
        [self.lab setFrame:CGRectMake(0, 0, self.cachedImageView.frame.size.width, self.cachedImageView.frame.size.height)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeTextMessage:)]) {
            [self.delegate removeTextMessage:_message];
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

- (void)burnMessage{
    NSString *time;
    self.lab = [[UILabel alloc] init];
    self.lab.backgroundColor = [UIColor redColor];
    self.lab.alpha = 0.3;
    [_cachedImageView addSubview:self.lab];
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
        time = dataStringss - sendTimess>10?@"0":[NSString stringWithFormat:@"%d",sendTimess-dataStringss +10];
    }else{
        NSString *ssSendTime = [sendTime substringWithRange:NSMakeRange(17,2)];
        NSString *ssDateString = [dateString substringWithRange:NSMakeRange(18,2)];
        int sendTimess = [ssSendTime intValue];
        int dataStringss = [ssDateString intValue]+60;
        time = dataStringss - sendTimess >10?@"0":[NSString stringWithFormat:@"%d",sendTimess-dataStringss +10];
    }
    NSTimer *timer;
    [self.lab setFrame:CGRectMake(0, 0, (self.cachedImageView.frame.size.width)*(10-[time intValue])/10, self.cachedImageView.frame.size.height)];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:time,@"time", nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backTime:) userInfo:dic repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
}

- (MLExpression *)getMLExpression
{
    if (!exp) {
        MLExpression *expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"LDDExpression" bundleName:@"LDDCExpression"];
        exp = expression;
    }
    return exp;
}

#pragma mark --屏幕摇动动画
- (void)shakeAnimationForView:(UIView *) viewToShake
{
    CGFloat t = 7.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:6.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(textMessageViewDidResponserInstructMessage:)]) {
                    [self.delegate textMessageViewDidResponserInstructMessage:_message];
                }

            }];
        }
    }];
}
@end
