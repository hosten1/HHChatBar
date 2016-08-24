//
//  LDLoginTableViewCell.h
//  Linkdood
//
//  Created by renxin-.- on 16/1/18.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDLoginTableViewCellDelegate <NSObject>

@optional
- (void)server:(NSString *)server;
- (void)account:(NSString *)account;
- (void)password:(NSString *)password;

@end
@interface LDLoginTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *server;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *identifyCode;
@property (weak, nonatomic) IBOutlet UILabel *nationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identifyImage;
@property (weak, nonatomic) IBOutlet UILabel *phoneOrEmail;
@property (weak,nonatomic) id<LDLoginTableViewCellDelegate> delegate;

@end
