//
//  LDNearbyAddBuddyCollectionCell.h
//  Linkdood
//
//  Created by VRV2 on 16/8/8.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDNearbyAddBuddyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (strong,nonatomic) LDUserModel *userModelCell;

@end
