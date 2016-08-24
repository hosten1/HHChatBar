//
//  HHChatBarView.m
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHChatBarView.h"
#import "HHChatPopupTableView.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
#define KViewHeight  self.frame.size.height
#define KCellHeight 30.0f
#define WEAKSELF __weak __typeof(&*self)weakSelf = self;

@interface HHChatBarView ()
@property(nonatomic,assign)NSInteger oldBtnTargt;
@property(nonatomic,strong)HHChatPopupTableView *oldPopView;
@property(nonatomic,copy)NSArray *sourcesArray;
@property (assign,nonatomic) bool Hiddent;
@property (assign,nonatomic) NSInteger count;

@end

@implementation HHChatBarView
-(instancetype)initWithDictionary:(NSDictionary *)resourcesDic{
    if (self == [super init]) {
        self.frame = CGRectMake(0,kScreenSize.height-KViewHeight,kScreenSize.width,KViewHeight);
        self.backgroundColor = [UIColor colorWithRed:0.927 green:0.937 blue:0.907 alpha:1.000];
        if (resourcesDic) {
             self.resourseDictionary = resourcesDic;
        }
        [self initLeftBarButton];
    }
    return self;
}
#pragma mark  -- 父视图改变时 改变子视图
-(void)layoutSubviews{
    [super layoutSubviews];
    self.leftContaintsView.frame = CGRectMake(0, 1, 45, KViewHeight-1);
    self.leftBtn.frame = CGRectMake(0,0, 30, 30);
    self.leftBtn.center = self.leftContaintsView.center;
    [self layoutRightSubButton];
}
-(void)layoutRightSubButton{
    NSArray *subArray = self.rightSubButtonView.subviews;
    CGFloat contentViewX = CGRectGetMaxX(self.leftContaintsView.frame)+6;
    CGFloat contetViewWid = kScreenSize.width - contentViewX-6;
    self.rightSubButtonView.frame = CGRectMake(contentViewX, 1, contetViewWid, self.frame.size.height-10);
    NSInteger count = self.count;
    
    CGFloat margin = 2;
    
    CGFloat itemWidth = (contetViewWid-margin)/count;
    CGFloat itemY = 1;
    UIButton *item ;
    for (NSInteger i = 0; i <subArray.count; i++) {
        UIView *subViewBtn = subArray[i];
        if ([subViewBtn isKindOfClass:[UIButton class]]) {
            item = (UIButton*)subViewBtn;
            CGFloat itemX = i * (itemWidth + margin);
            item.frame = CGRectMake(itemX, itemY, itemWidth, KViewHeight-1);
        }
    }

}
-(void)setResourseDictionary:(NSDictionary *)resourseDictionary{
    _resourseDictionary = resourseDictionary;
    self.sourcesArray = resourseDictionary[@"menu"];
}
//初始化左边的按钮
-(void)initLeftBarButton{
    UIView *leftContaintsView = [[UIView alloc]init];
    [self addSubview:leftContaintsView];
    self.leftContaintsView = leftContaintsView;
    UIButton *leftButton = [[UIButton alloc]init];
    self.leftBtn = leftButton;
    [leftContaintsView addSubview:leftButton];
    [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"bubble_left_default"] forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor clearColor];
    [self.self.leftBtn addTarget:self action:@selector(rightBtnClickWithChatItemView:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)setupSubviewItems{
    if (self.rightSubButtonView) {
        [self.rightSubButtonView removeFromSuperview];
    }
    UIView *rightBtnView = [[UIView alloc]init];
    [self addSubview:rightBtnView];
    self.rightSubButtonView = rightBtnView;
    NSInteger count;
    if (self.ChatDelegate && [self.ChatDelegate respondsToSelector:@selector(numberOfSectionWithchatBar:)]) {
         count = [self.ChatDelegate  numberOfSectionWithchatBar:self];
    }
    if (!count) {
        count = 1;
    }
    self.count = count;
    UIButton *item ;
    for (NSInteger i = 0; i < count; i++) {
        NSString *title;
        if (self.ChatDelegate && [self.ChatDelegate respondsToSelector:@selector(chatBar:sectionTitleWithIndexPath:)]) {
            title = [self.ChatDelegate  chatBar:self sectionTitleWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        }
        if (!title) {
            title = @"帮助";
        }
        item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [rightBtnView addSubview:item];
        [item addTarget:self action:@selector(buttonClickWithChatItemView:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = 2016819+i;
        [item setBackgroundColor:[UIColor colorWithRed:0.619 green:0.581 blue:0.566 alpha:1.000]];
    
    }
}
-(void)buttonClickWithChatItemView:(UIButton*)sender{
    
    NSInteger section = sender.tag - 2016819;
    NSArray *titileArray;
    if (self.ChatDelegate && [self.ChatDelegate respondsToSelector:@selector(chatBar:subPopViewTitleOfRowWithIndexPath:)]) {
        titileArray = [self.ChatDelegate  chatBar:self subPopViewTitleOfRowWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    }
    if (!titileArray || titileArray.count == 0) {
        if (self.ChatDelegate && [self.ChatDelegate respondsToSelector:@selector(chatBar:didSelectIndex:)]) {
            [self.ChatDelegate chatBar:self didSelectIndex:[NSIndexPath indexPathForRow:0 inSection:section]];
        }
        return;
    }else{
        NSInteger subCount = titileArray.count;
        CGFloat height = KCellHeight*subCount;
        
        CGFloat width;
        if (self.count > 3 || self.count == 1) {
            width = 100;
        }else{
            width = sender.frame.size.width;
        }
        CGFloat x;
        if (self.count == 4||self.count == 5||self.count == 6) {
            x = sender.frame.origin.x+2-10;
        }else{
            x = sender.frame.origin.x+2;
        }
        
        CGFloat y = kScreenSize.height-sender.frame.size.height-10 - height;
        HHChatPopupTableView *popView;
        WEAKSELF
        if (self.oldPopView) {
            if (self.oldBtnTargt != section) {
                [self.oldPopView hideView];
                [self.oldPopView removeFromSuperview];
                popView = [[HHChatPopupTableView alloc]initWithFrame:CGRectMake(x,y,width,KCellHeight) titleArray:titileArray];
                self.oldPopView = popView;
                popView.indexValue = section;
                self.oldBtnTargt = section;
                self.Hiddent = NO;
                [self.superview addSubview:popView];
                popView.tableViewCallBack = ^(NSIndexPath *index){
                    //                 NSLog(@"sss  %ld  section:%ld",index.row,index.section);
                    if (weakSelf.ChatDelegate && [weakSelf.ChatDelegate respondsToSelector:@selector(chatBar:didSelectIndex:)]) {
                        [weakSelf.ChatDelegate chatBar:weakSelf didSelectIndex:index];
                    }
                };
            }else{
                if (!self.Hiddent) {
                    self.Hiddent = [self.oldPopView hideView];
                }else{
                    [self.oldPopView showView];
                    self.oldPopView.indexValue = section;
                    self.oldPopView.tableViewCallBack = ^(NSIndexPath *index){
                        //                     NSLog(@"aaa  %ld  section:%ld",index.row,index.section);
                        if (weakSelf.ChatDelegate && [weakSelf.ChatDelegate respondsToSelector:@selector(chatBar:didSelectIndex:)]) {
                            [weakSelf.ChatDelegate chatBar:weakSelf didSelectIndex:index];
                        }
                    };
                    self.Hiddent = NO;
                }
                
            }
        }else{
            popView = [[HHChatPopupTableView alloc]initWithFrame:CGRectMake(x,y,width ,KCellHeight) titleArray:titileArray];
            self.oldPopView = popView;
            popView.indexValue = section;
            self.oldBtnTargt = section;
            self.Hiddent = NO;
            [self.superview addSubview:popView];
            popView.tableViewCallBack = ^(NSIndexPath *index){
                //            NSLog(@"ddd  %ld  section:%ld",index.row,index.section);
                if (weakSelf.ChatDelegate && [weakSelf.ChatDelegate respondsToSelector:@selector(chatBar:didSelectIndex:)]) {
                    [weakSelf.ChatDelegate chatBar:weakSelf didSelectIndex:index];
                }
            };
        }
        
    }
    
    
}


-(void)rightBtnClickWithChatItemView:(UIButton*)sender{
    if (self.oldPopView) {
        [self.oldPopView hideView];
    }
    if (self.ChatDelegate && [self.ChatDelegate respondsToSelector:@selector(chatBar:didClickRithtButton:)]) {
        [self.ChatDelegate chatBar:self didClickRithtButton:sender];
    }
}
@end
