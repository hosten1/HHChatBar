//
//  ExpressionImageView.h
//  IM
//
//  Created by 朱建宇 on 15/12/28.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExpressionImageView;
@protocol ExpressionClickedDelegate <NSObject>

-(void)didtapClicked:(NSInteger)tag;

-(void)didlongClicked:(ExpressionImageView *)point;

-(void)didmissClicked;

@end

@interface ExpressionImageView : UIImageView
{
    NSDate *startTime;
    NSDate *endTime;
}

@property (weak,nonatomic) id<ExpressionClickedDelegate>delegate;
@property (strong,nonatomic) UIScrollView *scrollView;
@end

