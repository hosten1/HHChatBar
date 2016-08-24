//
//  LegendOrganizationHeaderView.m
//  IM
//
//  Created by spinery on 15/6/18.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import "LDOrganizationHeaderView.h"

@implementation LDOrganizationHeaderView

-(void)refreshOrganization:(LDOrganizationModel*)org
{
    //组织数据
    if (!_orgs) {
        _orgs = [[NSMutableArray alloc] initWithObjects:org, nil];
    }else{
        [_orgs addObject:org];
    }
    
    //将父组织节点置灰
    for (UIView *child in _orgsPlate.subviews) {
        if ([child isKindOfClass:[UIButton class]]) {
            [(UIButton*)child setBackgroundImage:[[UIImage imageNamed:@"history_path"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 21)] forState:UIControlStateNormal];
        }
    }
    
    //将当前组织节点高亮
    UIButton *orgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orgBtn setBackgroundImage:[[UIImage imageNamed:@"curent_path"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 21)] forState:UIControlStateNormal];
    [orgBtn setTitle:org.orgName forState:UIControlStateNormal];
    [orgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [orgBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [orgBtn setTag:[_orgs count]];
    [orgBtn addTarget:self action:@selector(showOrganization:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size = [org.orgName boundingRectWithSize:_orgsPlate.size
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:orgBtn.titleLabel.font}
                                            context:nil].size;
    [orgBtn setFrame:(CGRect){_plateContentX == 0?0:_plateContentX - 17,0,ceil(size.width) + 70,35}];
    [_orgsPlate addSubview:orgBtn];
    _plateContentX = orgBtn.maxX;
    [_orgsPlate setContentSize:(CGSize){_plateContentX > _orgsPlate.width?_plateContentX:_orgsPlate.width,_orgsPlate.height}];
    if (_plateContentX > _orgsPlate.width) {
        [_orgsPlate setContentOffset:(CGPoint){_plateContentX - _orgsPlate.width,0} animated:YES];
    }else{
        [_orgsPlate setContentOffset:(CGPoint){0,0} animated:YES];
    }
    
    //刷新组织节点数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadChildWith:)]) {
        [self.delegate loadChildWith:org];
    }
}

- (void)showOrganization:(UIButton*)button
{
    //如果点击的是当前节点,不做任何处理
    if (button.tag == _orgs.count) {
        return;
    }
    
    _plateContentX = button.minX + 17;
    for (UIView *child in _orgsPlate.subviews) {
        if ([child isKindOfClass:[UIButton class]] && child.tag >= button.tag) {
            [child removeFromSuperview];
        }
    }
    for (int i = 0; i < [_orgs count] - button.tag; i++) {
        [_orgs removeObjectAtIndex:button.tag];
    }
    [self refreshOrganization:[_orgs objectAtIndex:button.tag - 1]];
}

- (void)clearOrganization
{
    _plateContentX = 0;
    [_orgs removeAllObjects];
    for (UIView *child in _orgsPlate.subviews) {
        [child removeFromSuperview];
    }
}

@end
