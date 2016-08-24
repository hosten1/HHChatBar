//
//  AudioRecoderPanel.m
//  Linkdood
//
//  Created by 熊清 on 16/6/24.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "AudioRecoderPanel.h"

#define MAX_RECORDTIME          60

@interface AudioRecoderPanel()<UIGestureRecognizerDelegate>
{
    IBOutlet UIButton *recoder;
    IBOutlet UILabel *tipLabel;
    IBOutlet UILabel *remindLabel;
    IBOutlet UIImageView *completeBtn;
    IBOutlet UIImageView *trashBtn;
    IBOutlet UIPanGestureRecognizer *panGesture;
    IBOutlet UILabel *permissionLabel;
    NSString *audioPath;
    CGPoint oldPoint;
    NSTimer *recoderTimer;
    int recoderSecond;
}

@end

@implementation AudioRecoderPanel

-(void)awakeFromNib
{
    [super awakeFromNib];
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [avSession requestRecordPermission:^(BOOL available) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (available) {
                    oldPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, recoder.center.y);
                    recoderSecond = MAX_RECORDTIME;
                    [recoder setImage:[recoder.currentImage imageMaskedWithColor:RGBACOLOR(50, 173, 238, 1.0)] forState:UIControlStateNormal];
                    [completeBtn setImage:[completeBtn.image imageMaskedWithColor:RGBACOLOR(50, 173, 238, 1.0)]];
                    [trashBtn setImage:[trashBtn.image imageMaskedWithColor:RGBACOLOR(50, 173, 238, 1.0)]];
                    _recordAudio = [[RecordAudio alloc] init];
                    [permissionLabel setHidden:YES];
                    [recoder setHidden:NO];
                    [tipLabel setHidden:NO];
                    [remindLabel setHidden:NO];
                }else{
                    [permissionLabel setHidden:NO];
                    
                    [recoder setHidden:YES];
                    [tipLabel setHidden:YES];
                    [remindLabel setHidden:YES];
                }
            });
            
        }];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)tapRecoder:(id)sender
{
    if (recoderTimer.isValid) {
        return;
    }
    recoderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [remindLabel setText:@"左滑发送,右滑删除"];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        recoder.alpha = 0.3;
    } completion: nil];
    [self setTipText];
    
    //开始录音
    [_recordAudio startRecord:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRecoder)]) {
        [self.delegate startRecoder];
    }
}

- (IBAction)panGestureAction:(UIPanGestureRecognizer*)pan
{
    if (!recoderTimer.isValid) {
        return;
    }
    CGPoint point = [pan translationInView:self];
    [recoder setCenter:(CGPoint){oldPoint.x + point.x,oldPoint.y}];
    if (point.x < 0) {
        [completeBtn setAlpha:fabs(point.x) / recoder.width];
    }else{
        [trashBtn setAlpha:fabs(point.x) / recoder.width];
    }
    if (fabs(point.x) >= recoder.width) {
        [remindLabel setText:point.x < 0?@"松开发送":@"松开删除"];
    }else{
        [remindLabel setText:@"左滑发送|右滑删除"];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            [recoder setCenter:self.center];
            [recoder setImage:[recoder.currentImage imageMaskedWithColor:RGBACOLOR(50, 173, 238, 1.0)] forState:UIControlStateNormal];
            if (point.x < 0) {
                [completeBtn setAlpha:0];
            }else{
                [trashBtn setAlpha:0];
            }
        }];
        if (fabs(point.x) >= recoder.width) {
            [self endRecoder:point];
        }
    }
}

- (void)updateTimer
{
    recoderSecond -= 1;
    [self setTipText];
    
    if (recoderSecond == 0) {
        [self endRecoder:CGPointMake(0, 0)];
    }
}

- (void)setTipText
{
    NSString *prefix = (recoderSecond % MAX_RECORDTIME) > 0?@"00":@"01";
    NSString *suffix = recoderSecond >= 10?((recoderSecond % MAX_RECORDTIME) == 0?@"00":[NSString stringWithFormat:@"%d",recoderSecond]):[NSString stringWithFormat:@"0%d",recoderSecond];
    [tipLabel setText:[NSString stringWithFormat:@"%@:%@",prefix,suffix]];
}

- (void)endRecoder:(CGPoint)point{
    if (point.x > 0) {
        [_recordAudio cancelRecord];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRecoder)]) {
            [self.delegate cancelRecoder];
        }
    }else{
        NSURL *audioUrl = [_recordAudio stopRecord];
        if (self.delegate && [self.delegate respondsToSelector:@selector(completeRecoder:)]) {
            [self.delegate completeRecoder:audioUrl];
        }
    }
    
    [recoderTimer invalidate];
    [recoder setAlpha:1.0];
    [recoder.layer removeAllAnimations];
    recoderSecond = MAX_RECORDTIME;
    [tipLabel setText:@"点击开始录音"];
    [remindLabel setText:@""];
    [completeBtn setAlpha:0];
    [trashBtn setAlpha:0];
}

@end
