//
//  LDDatePickerView.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDDatePickerView.h"

@implementation LDDatePickerView
- (void)datePickView:(NSDate *)date;
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView.backgroundColor = RGBACOLOR(1, 1, 1, 0.3);
    [self addSubview:_backView];
    _view = [[UIView alloc] initWithFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220)];
    _view.backgroundColor = RGBACOLOR(1, 1, 1, 0.5);
    [_backView addSubview:_view];
    [UIView animateWithDuration:0.3 animations:^{
        [_view setFrame:CGRectMake(0, SCREEN_HEIGHT-220, SCREEN_WIDTH, 220)];
    }];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lab.backgroundColor = [UIColor grayColor];
    [_view addSubview:lab];
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:RGBACOLOR(0, 183, 238, 1) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleTap) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:cancleBtn];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0, 50, 40)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureTap) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:RGBACOLOR(0, 183, 238, 1) forState:UIControlStateNormal];
    [_view addSubview:sureBtn];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 180)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *minDate = [dateFormatter dateFromString:@"1970-01-01 7:00:00"];
    NSDate *maxDate = [dateFormatter dateFromString:@"2037-12-31 7:00:00"];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:datePicker];
    datePicker.date = date;
    [_view addSubview:datePicker];
}

- (void)cancleTap
{
    [UIView animateWithDuration:0.3 animations:^{
        [_view setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220)];
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)sureTap
{
    NSTimeInterval timeStamp = [_birDate timeIntervalSince1970];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureAction:)]) {
        [self.delegate sureAction:timeStamp];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_view setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220)];
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancleTap];
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    _birDate = control.date;
}

@end
