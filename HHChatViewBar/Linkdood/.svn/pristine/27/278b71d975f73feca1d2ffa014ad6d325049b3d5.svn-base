//
//  ExpressionImageView.m
//  IM
//
//  Created by 朱建宇 on 15/12/28.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "ExpressionImageView.h"

@implementation ExpressionImageView
{
    BOOL start;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    start = NO;
    startTime = [NSDate date];
    UITouch *touch = [touches anyObject];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (startTime!= nil) {
            UIView *touchView =  [self.scrollView hitTest:[touch locationInView:self.scrollView] withEvent:event];
            if ([self.delegate respondsToSelector:@selector(didlongClicked:)]) {
                if ([touchView isKindOfClass:[ExpressionImageView class]]) {
                    start = YES;
                    [self.delegate didlongClicked:(ExpressionImageView*)touchView];
                }
            }
        }
    });
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (start == YES) {
        UITouch *touch = [touches anyObject];
        if ([self.delegate respondsToSelector:@selector(didmissClicked)]) {
            UIView *touchView =  [self.scrollView hitTest:[touch locationInView:self.scrollView] withEvent:event];
            if ([touchView isKindOfClass:[ExpressionImageView class]]) {
                [self.delegate didlongClicked:(ExpressionImageView*)touchView];
            }
        }
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    start = NO;
    startTime = nil;
    if ([self.delegate respondsToSelector:@selector(didmissClicked)]) {
        [self.delegate didmissClicked];
    }
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    endTime = [NSDate date];
    NSTimeInterval now = [endTime timeIntervalSince1970]*1000;
    NSTimeInterval late = [startTime timeIntervalSince1970]*1000;
    
    NSTimeInterval cha = now - late;
    if (cha>=0.5*1000) {
        if ([self.delegate respondsToSelector:@selector(didmissClicked)]) {
            [self.delegate didmissClicked];
        }
    }else
    {
        if ([self.delegate respondsToSelector:@selector(didtapClicked:)]) {
            [self.delegate didtapClicked:self.tag];
        }
    }
    start = NO;
    startTime = nil;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
