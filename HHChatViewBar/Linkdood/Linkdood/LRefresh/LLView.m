//
//  LLView.m
//  Demo
//
//  Created by 李乐 on 16/7/8.
//  Copyright © 2016年 beixinyuan. All rights reserved.
//

#import "LLView.h"
#import "LLItem.h"

CGFloat const WH = 40.0f;// 按钮的宽和高
CGFloat const MYVIEW_HEIGHT = 64;/** LLView对象的高度 */
int const INDEX_START = 1000;

// 上一次选中的索引
static NSInteger previousSelectedIndex;
static NSInteger newSelectedIndex;
static NSInteger oldStep;
static CGFloat defaultTopInsets;

@interface LLView ()
{
    CGFloat oldOffsetY;
    bool isDragging;
    CGFloat y;
}
@property (nonatomic, strong) NSArray *items;

@end

@implementation LLView

- (instancetype)initWithTableView:(UITableView*)tableView items:(NSArray<LLItem *> *)items target:(UIViewController *)target
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MYVIEW_HEIGHT)];
    if (self) {
        _items = items;
        defaultTopInsets = tableView.contentInset.top;
        [tableView setContentInset:UIEdgeInsetsMake(defaultTopInsets - MYVIEW_HEIGHT, 0, defaultTopInsets, 0)];
        oldOffsetY = self.frame.size.height - tableView.contentOffset.y;
        [tableView setTableHeaderView:self];
        
        [self setupSubviews];
        
        oldStep = 1;
        y = 0.0f;
    }
    return self;
}

+ (instancetype)viewWithTableView:(UITableView*)tableView items:(NSArray<LLItem *> *)items target:(UIViewController *)target
{
    return [[self alloc] initWithTableView:tableView items:items target:target];
}

/**
 *  根据模型数组初始化按钮
 */
- (void)setupSubviews
{
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - WH*_items.count) / (_items.count + 1);
    for (int i = 0; i < _items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(margin*(i+1)+WH*i, (MYVIEW_HEIGHT-WH) / 2, WH, WH);
        btn.tag = INDEX_START + i;
        btn.userInteractionEnabled = NO;
        LLItem *item  = _items[i];
        if (item.itemName != nil) {
            [btn setTitle:item.itemName forState:UIControlStateNormal];
            [btn setTitle:item.itemName forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        }
        if (item.normalImage != nil) {
            [btn setImage:item.normalImage forState:UIControlStateNormal];
            [btn setImage:(item.selectedImage == nil?item.normalImage:item.selectedImage) forState:UIControlStateSelected];
        }
        if (i == 0) {
            btn.selected = YES;
            previousSelectedIndex = i;
        }
        [self addSubview:btn];
    }
}

#pragma mark -
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    isDragging = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDragging = YES;
}

- (void)viewDidEndDragging:(UIScrollView *)scrollView
{
    if (previousSelectedIndex != newSelectedIndex) {
        previousSelectedIndex = newSelectedIndex;
        [self.delegate refreshTableDataWithIndex:previousSelectedIndex];
    }
    isDragging = NO;
}

- (void)viewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0) return;
    if (!isDragging) {
        return;
    }
    int step = fabs(scrollView.contentOffset.y - oldOffsetY) / (MYVIEW_HEIGHT + defaultTopInsets);
    if (step >= _items.count) {
        return;
    }
    newSelectedIndex = previousSelectedIndex + step;
    newSelectedIndex = newSelectedIndex % 2;

//    NSLog(@"%ld - %ld - %ld - %d - %f", newSelectedIndex, previousSelectedIndex, oldStep, step, scrollView.contentOffset.y);
    if (step == 0 && previousSelectedIndex == newSelectedIndex && y < scrollView.contentOffset.y) {
        [self refreshBtnSelectedWithTag:(previousSelectedIndex + INDEX_START)];
        return;
    }

    if (newSelectedIndex != previousSelectedIndex) {
        [self refreshBtnSelectedWithTag:(newSelectedIndex + INDEX_START)];
        y = scrollView.contentOffset.y;
        if (step != oldStep) {
            previousSelectedIndex = newSelectedIndex;
            oldStep = step;
        }
    }
}

/**
 *  刷行按钮的选中状态
 */
- (void)refreshBtnSelectedWithTag:(NSInteger)tag
{
    for (UIButton *btn in self.subviews)
    {
        if (btn.isSelected) {
            [btn setSelected:NO];
        }
    }
    UIButton *selected = selected = [self viewWithTag:tag];
    if ([selected isKindOfClass:[UIButton class]]) {
        [selected setSelected:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    y = 0;
}

@end
