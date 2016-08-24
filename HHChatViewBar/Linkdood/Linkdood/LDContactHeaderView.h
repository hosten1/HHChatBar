//
//  LDContactHeaderView.h
//  IM
//
//  Created by spinery on 14-7-16.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDContactHeaderViewDelegate <NSObject>
@optional
- (void)changePhoto;
- (void)changeDoodNum;
- (void)changeRemarkWithContain:(LDContactModel*)contact remark: (NSString*)remarkString;
@end

@interface LDContactHeaderView : UIView <UIActionSheetDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIButton *header;
@property (strong, nonatomic) UIButton *name;
@property (strong, nonatomic) UIButton *remark;
@property (strong, nonatomic) LDContactModel *contact;
@property (strong, nonatomic) UITextField *changeRemarkFiled;
@property (weak, nonatomic) id <LDContactHeaderViewDelegate> delegate;

- (instancetype)initWithHeight:(CGFloat)height;
- (void)refreshWithUserInfo:(LDContactModel *)contact;
- (void)refreshWithMyselInfo:(LDUserModel *)myself;
- (void)statusChangeScroll:(UIScrollView *)scrollView;

@end
