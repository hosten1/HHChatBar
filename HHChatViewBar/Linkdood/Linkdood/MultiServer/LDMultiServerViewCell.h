//
//  LDMultiServerViewCell.h
//  Linkdood
//
//  Created by 熊清 on 16/8/3.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDMultiServerViewCellDelegate <NSObject>

- (void)switchMultiServer:(LDMultiServerModel*)multiServer;

@end

@interface LDMultiServerViewCell : UITableViewCell

@property (strong,nonatomic) LDMultiServerModel *multiServer;
@property (assign,nonatomic) id<LDMultiServerViewCellDelegate> delegate;

- (void)loginWithPassword:(NSString*)password;
- (void)exitLogin:(void (^) (bool success))result;

@end
