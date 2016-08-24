//
//  HHChatBarView.h
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHChatBarView;

@protocol HHChatBarDelegate <NSObject>
@required
/**
 *  设置有多少个条目
 *
 *  @param charBar
 *
 *  @return 返回条目个数
 */
-(NSInteger)numberOfSectionWithchatBar:(HHChatBarView*)charBar;
/**
 *  返回bar上的标题
 *
 *  @param charBar
 *  @param indexPath 索引值 取section
 *
 *  @return 当前item的标题
 */
-(NSString*)chatBar:(HHChatBarView*)charBar sectionTitleWithIndexPath:(NSIndexPath*)indexPath;
/**
 *  返回所有二级标题
 *
 *  @param charBar
 *  @param indexPath 二级标题索引 在indexPath.section
 *
 *  @return 放回所有二级标题的数组
 */
-(NSArray*)chatBar:(HHChatBarView *)charBar subPopViewTitleOfRowWithIndexPath:(NSIndexPath*)indexPath;
@optional
/**
 *  返回选中的项目
 *
 *  @param charBar
 *  @param indexPath 索引  indexPath.row  在视图中自上而下0，1，2...
 */
-(void)chatBar:(HHChatBarView*)charBar didSelectIndex:(NSIndexPath*)indexPath;
/**
 *  右侧按钮点击事件回调
 *
 *  @param charBar
 *  @param sender  点击的按钮
 */
-(void)chatBar:(HHChatBarView*)charBar didClickRithtButton:(UIButton*)sender;


@end

@interface HHChatBarView : UIView
/**
 *  数据字典  （目前不需要传）
 */
@property (copy,nonatomic) NSDictionary *resourseDictionary;
@property (assign,nonatomic) id<HHChatBarDelegate> ChatDelegate;
/**
 *  左侧按钮的view
 */
@property(nonatomic,strong)UIView *leftContaintsView;
/**
 *  包含所有subview的view
 */
@property (strong,nonatomic) UIView *rightSubButtonView;
@property(nonatomic,strong)UIButton *leftBtn;
/**
 *  初始化方法
 *
 *  @param resourcesDic (目前不需要 )
 *
 *  @return 
 */

-(instancetype)initWithDictionary:(NSDictionary*)resourcesDic;
-(void)setupSubviewItems;
@end
