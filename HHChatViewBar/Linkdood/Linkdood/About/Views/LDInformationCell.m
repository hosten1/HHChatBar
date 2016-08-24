//
//  LDInformationCell.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDInformationCell.h"

@implementation LDInformationCell

-(void)awakeFromNib{
    [self.textLabel setFont:[UIFont systemFontOfSize:14]];
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
}

- (void)initCell:(NSInteger )section rowNum:(NSInteger )row;
{
    LDUserModel *mySelf = MYSELF;
//    if (section == 0 && row == 0) {
//        [self.textLabel setText:@"头像"];
//        NSString *msgFrom = @"Unisex";
//        if (mySelf.sex == msg_owner_male) {
//            msgFrom = @"MaleIcon";
//        }
//        if (mySelf.sex == msg_owner_female) {
//            msgFrom = @"FemaleIcon";
//        }
//        UIImageView *header = [[UIImageView alloc] initWithImage:[[LDClient sharedInstance] avatar:mySelf.avatar withDefault:msgFrom]];
//        [header setFrame:(CGRect){0,0,60,60}];
//        self.accessoryView = header;
//    }
//    if (section == 0 && row == 1) {
//        [self.textLabel setText:@"豆豆号"];
//        if (![mySelf.nickID isEmpty]) {
//            [self.detailTextLabel setText:[[mySelf.nickID componentsSeparatedByString:@"/"] firstObject]];
//            self.accessoryType = UITableViewCellAccessoryNone;
//        }else{
//            [self.detailTextLabel setText:@"请设置豆豆号"];
//        }
//    }
    if (section == 0 && row == 0) {
        [self.textLabel setText:@"昵称"];
        [self.detailTextLabel setText:mySelf.name];
    }
    if (section == 0 && row == 1) {
        [self.textLabel setText:@"性别"];
        NSString *sex = @"保密";
        if (mySelf.sex == msg_owner_male) {
            sex = @"男";
        }
        if (mySelf.sex == msg_owner_female) {
            sex = @"女";
        }
        [self.detailTextLabel setText:sex];
    }
    if (section == 0 && row == 2) {
        [self.textLabel setText:@"生日"];
        [self.detailTextLabel setText:[[NSString stringWithFormat:@"%lld",mySelf.birthday / 1000] dateString:@"yyyy-MM-dd" forTimeZone:nil]];
    }
    if (section == 0 && row == 3) {
        [self.textLabel setText:@"地区"];
        if (![mySelf.area isEmpty]) {
            [self.detailTextLabel setText:mySelf.area];
        }else{
            [self.detailTextLabel setText:@"请选择地区"];
        }
    }
    if (section == 0 && row == 4) {
        [self.textLabel setText:@"个性签名"];
        [self.detailTextLabel setText:mySelf.sign];
    }
    if (section == 1 && row == 0) {
        [self.textLabel setText:@"电话"];
        if (mySelf.phones.count > 0) {
            NSMutableString *phone = [[NSMutableString alloc] initWithString:[mySelf.phones firstObject]];
            [phone deleteCharactersInRange:NSMakeRange(0,4)];
            [phone insertString:@"-" atIndex:3];
            [phone insertString:@"-" atIndex:8];
            [self.detailTextLabel setText:phone];
        }else{
            [self.detailTextLabel setText:@"绑定手机提高账号安全级别"];
        }
    }
    if (section == 1 && row == 1) {
        [self.textLabel setText:@"邮箱"];
        if (mySelf.emails.count > 0) {
            [self.detailTextLabel setText:[mySelf.emails firstObject]];
        }else{
            [self.detailTextLabel setText:@"绑定邮箱提高账号安全级别"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
