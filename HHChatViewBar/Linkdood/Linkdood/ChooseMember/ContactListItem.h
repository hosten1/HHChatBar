//
//  LDRootTableViewController.h
//  Linkdood
//
//  Created by VRV on 15/12/31.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ContactListItem : UIView {
    CGRect textRect;
    CGRect imageRect;
}

@property (nonatomic, retain) NSObject *objectTag;
@property (nonatomic, retain) NSString *imageTitle;
@property (nonatomic, retain) UIImage  *image;
@property (nonatomic, retain) LDContactModel  *tinyBuddyBean;

- (id)initWithFrame:(CGRect)frame TinyBuddyBean:(LDContactModel *)tiny;

@end
