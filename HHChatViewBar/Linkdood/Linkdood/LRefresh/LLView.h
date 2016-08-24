//
//  LLView.h
//  Demo
//
//  Created by 李乐 on 16/7/8.
//  Copyright © 2016年 beixinyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLItem.h"

@class LLItem;
@class LLView;
@protocol LLViewDelegate <NSObject>

/**
 *  刷新tableView中数据的代理方法，当选择的按钮发生变化时就会被触发
 *
 *  index  :   所选择的按钮的索引,当选中第 n 个按钮时，则该索引就为 n-1, 方便tableView选择要加载的数据
 */
- (void)refreshTableDataWithIndex:(NSInteger)seletedIndex;

@end

@interface LLView : UIView

@property (nonatomic,assign) id<LLViewDelegate> delegate;

/**
 * 对象方法初始化方法
 *
 * tableView  :  外界的viewController上的tableView
 * items      :  属性数组，数组中存放的是字典，字典的键为：itemName, normalImgName, selectedImgName, 分别代表名称、正常状态下的图片、选中状态下的图片，赋值时有三种情况
              1> 只有名称
              2> 只有普通图片和选中图片
              3> 名称，普通图片和选中图片都有

 * target     :  外界的控制器
 * 返回初始化好的LLView对象
 */
- (instancetype)initWithTableView:(UITableView*)tableView items:(NSArray<LLItem *> *)items target:(UIViewController *)target;

/**
 * 类方法初始化方法
 *
 * tableView  :  外界的viewController上的tableView
 * items      :  属性数组，数组中存放的是字典，字典的键为：itemName, normalImgName, selectedImgName, 分别代表名称、正常状态下的图片、选中状态下的图片，赋值时有三种情况
                1> 只有名称
                2> 只有普通图片和选中图片
                3> 名称，普通图片和选中图片都有
 
 * target     :  外界的控制器
 * 返回初始化好的LLView对象
 */
+ (instancetype)viewWithTableView:(UITableView*)tableView items:(NSArray<LLItem *> *)items target:(UIViewController *)target;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

/**
 *  在tableView的viewDidEndDragging:方法中调用该方法
 *
 *  scrollView  :   tableView的viewDidEndDragging:方法中的scrollView参数
 */
- (void)viewDidEndDragging:(UIScrollView *)scrollView;

/**
 *  在tableView的viewDidScroll:方法中调用该方法
 *
 *  scrollView  :   tableView的viewDidScroll:方法中的scrollView参数
 */
- (void)viewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
