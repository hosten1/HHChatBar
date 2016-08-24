
//
//  LDContactFooterView.m
//  IMNew
//
//  Created by VRV on 15/12/2.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDPersonFooterView.h"

@implementation LDPersonFooterView

- (void)sendMessage
{
    UIButton *sendbtn = [[UIButton alloc] init];
    [sendbtn setFrame:CGRectMake(7, 0, SCREEN_WIDTH-23, 42)];
    sendbtn.backgroundColor = [UIColor whiteColor];
    sendbtn.layer.borderWidth = 1;
    sendbtn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    [sendbtn.layer setCornerRadius:5];
    [sendbtn setTitle:@"发送消息" forState:UIControlStateNormal];
    sendbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sendbtn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    [sendbtn addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendbtn];
}

- (void)addPerson
{
    UIButton *sendbtn = [[UIButton alloc] init];
    [sendbtn setFrame:CGRectMake(7, 0, SCREEN_WIDTH-23, 42)];
    sendbtn.backgroundColor = [UIColor whiteColor];
    sendbtn.layer.borderWidth = 1;
    sendbtn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    [sendbtn.layer setCornerRadius:5];
    [sendbtn setTitle:@"加为好友" forState:UIControlStateNormal];
    sendbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sendbtn setTitleColor:RGBACOLOR(0, 149, 192, 1) forState:UIControlStateNormal];
    [sendbtn addTarget:self action:@selector(addPersonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendbtn];
}

- (void)sendMessageAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMess)]) {
        [self.delegate sendMess];
    }
}

- (void)addPersonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addFriend)]) {
        [self.delegate addFriend];
    }
}

@end
