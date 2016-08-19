//
//  HHChatBarView.m
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHChatBarView.h"
#import "HHChatPopupTableView.h"

@interface HHChatBarView ()
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,assign)NSInteger oldBtnTargt;
@property(nonatomic,strong)HHChatPopupTableView *oldPopView;
@property (assign,nonatomic) bool Hiddent;
#define kScreenSize [UIScreen mainScreen].bounds.size
#define KViewHeight 35
@end

@implementation HHChatBarView
-(instancetype)initWithDictionary:(NSDictionary *)resourcesDic{
    if (self == [super init]) {
        self.frame = CGRectMake(0,kScreenSize.height-KViewHeight,kScreenSize.width,KViewHeight);
        self.backgroundColor = [UIColor colorWithRed:0.927 green:0.937 blue:0.907 alpha:1.000];
        [self initRightBarButton];
        [self setupSubviewItems];
        
    }
    return self;
}
-(void)initRightBarButton{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, 40, KViewHeight-1)];
    [self addSubview:rightView];
    self.rightView = rightView;
    UIButton *right = [[UIButton alloc]init];
    self.rightBtn = right;
    [rightView addSubview:right];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"block"] forState:UIControlStateNormal];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateHighlighted];
    right.frame = CGRectMake(0,0, 20, 20);
    right.center = rightView.center;
    right.backgroundColor = [UIColor colorWithRed:0.982 green:0.972 blue:0.952 alpha:1.000];
}
-(void)setupSubviewItems{
    NSInteger count = 4;
    CGFloat margin = 2;
    CGFloat rightX = self.rightView.frame.size.width;
    CGFloat itemWidth = (kScreenSize.width-rightX- margin*(count-1))/count;
    CGFloat itemY = 1;
    UIButton *item ;
    for (NSInteger i = 0; i < count; i++) {
        item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setTitle:@"测试" forState:UIControlStateNormal];
        [item setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:item];
        CGFloat itemX = rightX+ margin + i * (itemWidth + margin);
        item.backgroundColor = [UIColor colorWithRed:0.982 green:0.972 blue:0.952 alpha:1.000];
        item.frame = CGRectMake(itemX, itemY, itemWidth, KViewHeight-1);
        [item addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = 2016819+i;
    }
}
-(void)btnClick:(UIButton*)sender{
    NSInteger i = sender.tag - 2016819;
    CGFloat height = 30*3;
    NSInteger cout = 4;
    CGFloat width;
    if (cout > 3) {
        width = 100;
    }else{
         width = sender.frame.size.width-10;
    }
    CGFloat x = sender.frame.origin.x+2;
    CGFloat y = kScreenSize.height-sender.frame.size.height-10 - height;
    HHChatPopupTableView *popView;
    if (self.oldPopView) {
        if (self.oldBtnTargt != i) {
           [self.oldPopView hideView];
           [self.oldPopView removeFromSuperview];
            popView = [[HHChatPopupTableView alloc]initWithFrame:CGRectMake(x,y,width , height) titleArray:@[]];
            self.oldPopView = popView;
            popView.indexValue = i;
            self.oldBtnTargt = i;
            self.Hiddent = NO;
            [self.superview addSubview:popView];
            popView.tableViewCallBack = ^(NSIndexPath *index){
                 NSLog(@"sss  %ld  section:%ld",index.row,index.section);
            };
        }else{
            if (!self.Hiddent) {
               self.Hiddent = [self.oldPopView hideView];
            }else{
                [self.oldPopView showView];
                self.oldPopView.indexValue = i;
                self.oldPopView.tableViewCallBack = ^(NSIndexPath *index){
                     NSLog(@"aaa  %ld  section:%ld",index.row,index.section);
                };
                self.Hiddent = NO;
            }
            
        }
    }else{
        popView = [[HHChatPopupTableView alloc]initWithFrame:CGRectMake(x,y,width , height) titleArray:@[]];
        self.oldPopView = popView;
        popView.indexValue = i;
        self.oldBtnTargt = i;
        self.Hiddent = NO;
        [self.superview addSubview:popView];
        popView.tableViewCallBack = ^(NSIndexPath *index){
            NSLog(@"ddd  %ld  section:%ld",index.row,index.section);
        };
    }
    
}
@end
