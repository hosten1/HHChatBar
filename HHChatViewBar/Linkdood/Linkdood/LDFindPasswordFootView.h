//
//  LDFindPasswordFootView.h
//  Linkdood
//
//  Created by renxin-.- on 16/1/5.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDFindPasswordFootViewDelegate <NSObject>

@optional
-(void)findPassword;
@end
@interface LDFindPasswordFootView : UIView
@property (weak,nonatomic) id<LDFindPasswordFootViewDelegate> delegate;


- (void)footView;
@end
