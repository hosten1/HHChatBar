//
//  LDRootTableViewController.h
//  Linkdood
//
//  Created by VRV on 15/12/31.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "ContactListItem.h"

@implementation ContactListItem

- (id)initWithFrame:(CGRect)frame   TinyBuddyBean:(LDContactModel *)tiny
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        self.imageTitle = tiny.name;
        self.tinyBuddyBean =  tiny;
        
//        self.image = [NSString getImage:tiny.avatarUrl Default:@"sex_secret_nomal_big@2x.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
        NSString *msgFrom = @"Unisex";
        if (tiny.sex == msg_owner_male) {
            msgFrom = @"MaleIcon";
        }
        if (tiny.sex == msg_owner_female) {
            msgFrom = @"FemaleIcon";
        }
        [[LDClient sharedInstance] avatar:tiny.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
            [imageView setImage:avatar];
        }];
        UILabel *title = [[UILabel alloc] init];
        title.textAlignment= NSTextAlignmentCenter;
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFont:[UIFont boldSystemFontOfSize:8.0]];
        [title setOpaque: NO];
        [title setText:self.imageTitle];
        
        imageRect = CGRectMake(0.0, 8, 30, 30);
        
        textRect = CGRectMake(-3, 43, 37, 10);
        
        [title setFrame:textRect];
        [imageView setFrame:imageRect];
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.layer.masksToBounds = YES;
        [self addSubview:title];
        [self addSubview:imageView];
    }
    return self;
}

@end
