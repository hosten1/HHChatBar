//
//  LDRootTableViewController.h
//  Linkdood
//
//  Created by VRV on 15/12/31.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "ContactHorizontalList.h"

@implementation ContactHorizontalList

- (id)initWithFrame:(CGRect)frame title:(NSString *)title items:(NSMutableArray *)items
{
    self = [super initWithFrame:frame];

    if (self) {
        
        // scrollView
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 20, self.frame.size.width, 60)];
        CGSize pageSize = CGSizeMake(ITEM_WIDTH, 60);
        NSUInteger page = 0;
        
        for(ContactListItem *item in items) {
            [item setFrame:CGRectMake(15 + (pageSize.width + DISTANCE_BETWEEN_ITEMS) * page++, 0, pageSize.width, pageSize.height)];
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
            [item addGestureRecognizer:singleFingerTap];
            
            [self.scrollView addSubview:item];
        }
        
        self.scrollView.contentSize = CGSizeMake(15 + (pageSize.width + DISTANCE_BETWEEN_ITEMS) * [items count], 60);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        [self addSubview:self.scrollView];
        
        // Title Label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, self.frame.size.width, 30)];
        [titleLabel setText:[NSString stringWithFormat:@"   已选中%@",title]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [titleLabel setTextColor:[UIColor colorWithWhite:116.0/256.0 alpha:1.0]];
        [titleLabel setShadowColor:[UIColor whiteColor]];
        [titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        [titleLabel setOpaque:YES];
        [titleLabel setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [self addSubview:titleLabel];
    }
    
    return self;
}


// 点击选中的成员
- (void)itemTapped:(UITapGestureRecognizer *)recognizer {
    ContactListItem *item = (ContactListItem *)recognizer.view;
    if (item != nil) {
        if ([self.delegate respondsToSelector:@selector(touchDeleteMemberButton:)]) {
            [self.delegate touchDeleteMemberButton:item];
        }
    }
}

@end
