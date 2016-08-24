//
//  LDRootTableViewController.h
//  Linkdood
//
//  Created by VRV on 15/12/31.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ContactListItem.h"

#define DISTANCE_BETWEEN_ITEMS  15.0
#define LEFT_PADDING            15.0
#define ITEM_WIDTH              29

@protocol ContactHorizontalListDelegate <NSObject>
@required
- (void)touchDeleteMemberButton:(ContactListItem*)item;
@end

@interface ContactHorizontalList : UIView <UIScrollViewDelegate>{
    CGFloat scale;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) id parent;
@property (nonatomic, weak) id <ContactHorizontalListDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title items:(NSMutableArray *)items;

@end
