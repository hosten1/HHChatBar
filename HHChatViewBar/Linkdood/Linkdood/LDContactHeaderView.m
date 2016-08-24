//
//  LDContactHeaderView.m
//  IM
//
//  Created by spinery on 14-7-16.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import "LDContactHeaderView.h"

@implementation LDContactHeaderView

- (instancetype)initWithHeight:(CGFloat)height
{
    if (self = [super init]) {
        [self setFrame:(CGRect){0,0,SCREEN_WIDTH,height}];
        
        _background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        _background.userInteractionEnabled = YES;
        
        _header = [UIButton buttonWithType:UIButtonTypeCustom];
        [_header setFrame:(CGRect){0,0,70,70}];
        [_header setCenter:_background.center];
        [_header setCornerRadius:_header.width / 2];
        [_background addSubview:_header];

        if (height == 160) {
            [_header setCenter:CGPointMake(_background.center.x, _background.center.y+20)];
            _name = [[UIButton alloc] initWithFrame:CGRectMake(0, _header.maxY + 5, _background.width, 25)];
            [_name.titleLabel setTextAlignment:NSTextAlignmentCenter];
            _name.titleLabel.font = [UIFont systemFontOfSize:16];
            [_name setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            [_background addSubview:_name];
        }else{
            _remark = [[UIButton alloc] initWithFrame:CGRectMake(0, _header.maxY+10, _background.width, 25)];
            [_remark.titleLabel setTextAlignment:NSTextAlignmentCenter];
            _remark.titleLabel.font = [UIFont systemFontOfSize:16];
            [_remark setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            
            [_background addSubview:_remark];
            UIImage *image = [UIImage imageNamed:@"pencil"];
            [_remark setImage:image forState:(UIControlStateNormal)];
            [_remark setImage:[UIImage imageNamed:@"pencil_selec"] forState:UIControlStateHighlighted];
            _remark.hidden = YES;
            
            _changeRemarkFiled = [[UITextField alloc]init];
            _changeRemarkFiled.frame = CGRectMake(0, _header.maxY+10, _background.width, 25);
            _changeRemarkFiled.font = [UIFont systemFontOfSize:14];
            _changeRemarkFiled.returnKeyType = UIReturnKeyDone;
            _changeRemarkFiled.textColor = [UIColor whiteColor];
            [_changeRemarkFiled setTextAlignment:NSTextAlignmentCenter];
            _changeRemarkFiled.delegate = self;
            [_background addSubview:_changeRemarkFiled];
            _changeRemarkFiled.hidden = YES;
            
            _name = [[UIButton alloc] initWithFrame:CGRectMake(0, _remark.maxY + 5, _background.width, 25)];
            [_name.titleLabel setTextAlignment:NSTextAlignmentCenter];
            _name.titleLabel.font = [UIFont systemFontOfSize:16];
            [_name setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            [_background addSubview:_name];
            
           
 
        }
         [self addSubview:_background];
    }
    return self;
}

- (void)refreshWithUserInfo:(LDContactModel *)contact
{
    _contact = contact;
    _remark.hidden = NO;
    
    CGSize re ;
  
        if ([[[LDClient sharedInstance] contactListModel] itemWithID:self.contact.ID]) {
            if (![contact.remark isEmpty]) {
                [_remark setTitle:contact.remark forState:UIControlStateNormal];
                re = [contact.remark sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            }else{
                [_remark setTitle:@"未设置昵称" forState:UIControlStateNormal];
                re = [@"未设置昵称" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            }
            
        }else{
            _remark.hidden = YES;
        }

    [_name setTitle:contact.name forState:UIControlStateNormal];
      UIImage *image = [UIImage imageNamed:@"pencil"];
  
    [_remark setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [_remark setImageEdgeInsets:UIEdgeInsetsMake(0, re.width, 0, -re.width)];
    NSString *msgFrom = @"Unisex";
    if (contact.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (contact.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    if (contact.sex == 0) {
        _background.image = [UIImage imageNamed:@"Personal_info_intersex"];
    }else if(contact.sex == 1){
        _background.image = [UIImage imageNamed:@"Personal_info_men"];
    }else{
        _background.image = [UIImage imageNamed:@"Personal_info_women"];
    }
    
    [[LDClient sharedInstance] avatar:contact.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_header setBackgroundImage:avatar forState:UIControlStateNormal];
    }];
    [_remark addTarget:self action:@selector(changeRemark) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshWithMyselInfo:(LDUserModel *)myself
{
    if (myself.nickID == nil || [myself.nickID isEmpty]) {
        [_name setTitle:@"点击设置豆豆号" forState:UIControlStateNormal];
        [_name setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
        [_name addTarget:self action:@selector(changeDood) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_name setTitle:[@"豆豆号:" stringByAppendingString:[[myself.nickID componentsSeparatedByString:@"/"] firstObject]] forState:UIControlStateNormal];
    }
    NSString *msgFrom = @"Unisex";
    if (myself.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (myself.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    if (myself.sex == 0) {
        _background.image = [UIImage imageNamed:@"Personal_info_intersex"];
    }else if(myself.sex == 1){
        _background.image = [UIImage imageNamed:@"Personal_info_men"];
    }else{
        _background.image = [UIImage imageNamed:@"Personal_info_women"];
    }
    [[LDClient sharedInstance] avatar:myself.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [_header setBackgroundImage:avatar forState:UIControlStateNormal];
    }];
    [_header addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeRemark
{
    if (!_remark.isHidden) {
        _remark.hidden = YES;
        _changeRemarkFiled.hidden = NO;
        _changeRemarkFiled.text = _remark.titleLabel.text;
        [_changeRemarkFiled becomeFirstResponder];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   
    _changeRemarkFiled.hidden = YES;
    _remark.hidden = NO;
    [_remark setTitle:textField.text forState:UIControlStateNormal];
    CGSize re = [textField.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [_remark setImageEdgeInsets:UIEdgeInsetsMake(0, re.width, 0, -re.width)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeRemarkWithContain:remark:)]) {
        [self.delegate changeRemarkWithContain: _contact remark:textField.text];
    }
    return YES;
}
- (void)changeAvatar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePhoto)]) {
        [self.delegate changePhoto];
    }
}

- (void)changeDood
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDoodNum)]) {
        [self.delegate changeDoodNum];
    }
}

- (void)statusChangeScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if(offset.y > 0) {
        _background.alpha = (self.height - offset.y) / self.height;
        _header.alpha = (self.height - offset.y) / self.height;
        _name.alpha = (self.height - offset.y) / self.height;
        if ([[[LDClient sharedInstance] contactListModel] itemWithID:self.contact.ID]) {
            
            _remark.alpha = (self.height - offset.y) / self.height;
            _changeRemarkFiled.alpha = (self.height - offset.y) / self.height;
        }
        
    }
    else{
        [_background setFrame:CGRectMake(offset.y, offset.y, SCREEN_WIDTH - offset.y * 2, self.height - offset.y)];
        [_header setFrame:(CGRect){_background.width / 2 - _header.width / 2,_header.minY,_header.width,_header.width}];
        if ([[[LDClient sharedInstance] contactListModel] itemWithID:self.contact.ID]) {
            
            [_remark setFrame:CGRectMake(0, _header.maxY + 10, _background.width, 25)];
            [_changeRemarkFiled setFrame:CGRectMake(0, _header.maxY + 10, _background.width, 25)];
            [_name setFrame:CGRectMake(0, _remark.maxY + 5, _background.width, 25)];
        }else{
            [_name setFrame:CGRectMake(0, _header.maxY + 5, _background.width, 25)];
        }
        
        

    }
}

@end
