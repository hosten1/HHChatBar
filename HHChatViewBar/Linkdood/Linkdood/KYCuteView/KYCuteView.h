//
//  KYCuteView.h
//  KYCuteViewDemo
//
//  Created by Kitten Yang on 2/26/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^DismissBlock)(bool state);
@interface KYCuteView : UIView
@property (nonatomic , strong) DismissBlock returnBlock;
/**
 *  如果拖动 后需要在另一个view上处理的 设置为yes
 */
@property (assign,nonatomic)BOOL isSubview;
/**
 *  讲坐标转换到相对于窗口的坐标
 */
@property (strong,nonatomic) UIView *cover;
//父视图
//set the view which you wanna add the 'cuteBubble'
@property (nonatomic,strong)UIView *containerView;

//气泡上显示数字的label
//the label on the bubble
@property (nonatomic,strong)UILabel *bubbleLabel;

//气泡的直径
//bubble's diameter
@property (nonatomic,assign)CGFloat bubbleWidth;
//气泡的的宽度
//bubble's diameter
@property (nonatomic,assign)CGFloat bubbleHeight;

//气泡粘性系数，越大可以拉得越长
//viscosity of the bubble,the bigger you set,the longer you drag
@property (nonatomic,assign)CGFloat viscosity;

//气泡颜色
//bubble's color
@property (nonatomic,strong)UIColor *bubbleColor;

//需要隐藏气泡时候可以使用这个属性：self.frontView.hidden = YES;
//if you wanna hidden the bubble, you can ’self.frontView.hidden = YES‘
@property (nonatomic,strong)UIView *frontView;


-(id)initWithPoint:(CGPoint)point superView:(UIView *)view;
-(void)setUp;


@end
