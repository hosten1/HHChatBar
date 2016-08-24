//
//  LDDatePickerView.h
//  Linkdood
//
//  Created by renxin-.- on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDDatePickerViewDelegate <NSObject>
- (void)sureAction:(NSTimeInterval)date;


@end
@interface LDDatePickerView : UIView
- (void)datePickView:(NSDate *)date;
@property (nonatomic, strong) NSDate *birDate;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *backView;



@property (nonatomic, weak) id <LDDatePickerViewDelegate> delegate;

@end
