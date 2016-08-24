//
//  HHChatPopupTableView.h
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^indexCallBack)(NSIndexPath *index);

@interface HHChatPopupTableView : UIView
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray;
-(Boolean)hideView;
-(Boolean)showView;

@property (assign,nonatomic) CGFloat cellHeight;
@property (copy,nonatomic) NSArray *titleArray;
@property (assign,nonatomic) NSInteger indexValue;
@property (copy,nonatomic) indexCallBack tableViewCallBack;
@end
