//
//  LDComboMessageCell.h
//  Linkdood
//
//  Created by yue on 7/8/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "MLLinkLabel.h"
#import <UIKit/UIKit.h>

@interface LDComboMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet MLLinkLabel *message;
@property (weak, nonatomic) IBOutlet UILabel *time;


-(void)bindData:(LDMessageModel *)msg userInfo:(NSDictionary *)info;

@end
