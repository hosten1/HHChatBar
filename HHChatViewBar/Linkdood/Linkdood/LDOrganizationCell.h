//
//  LDOrganizationCell.h
//  Linkdood
//
//  Created by renxin-.- on 16/5/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDOrganizationCell : UITableViewCell
-(void)initCellOrg:(LDOrganizationModel *)org;

- (void)initCellUser:(LDEntpriseUserModel *)user;
@end
