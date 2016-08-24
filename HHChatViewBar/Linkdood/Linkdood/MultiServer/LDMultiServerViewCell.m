//
//  LDMultiServerViewCell.m
//  Linkdood
//
//  Created by 熊清 on 16/8/3.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDMultiServerViewCell.h"

@interface LDMultiServerViewCell()

@property (weak,nonatomic) IBOutlet UIImageView *header;
@property (weak,nonatomic) IBOutlet UIImageView *onlineStatus;
@property (weak,nonatomic) IBOutlet UILabel *account;
@property (weak,nonatomic) IBOutlet UILabel *message;
@property (weak,nonatomic) IBOutlet UIButton *switchBtn;

@end

@implementation LDMultiServerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(IBAction)switchToMainServer:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchMultiServer:)]) {
        [self.delegate switchMultiServer:_multiServer];
    }
}

- (void)setMultiServer:(LDMultiServerModel *)multiServer
{
    _multiServer = multiServer;
    if (!multiServer.name || multiServer.name.length == 0) {
        [_account setText:[NSString stringWithFormat:@"%@@%@",multiServer.multiServerUserInfo.name,multiServer.address]];
    }else{
        [_account setText:[NSString stringWithFormat:@"%@@%@",multiServer.name,multiServer.address]];
    }
    
    [_onlineStatus setImage:[UIImage imageNamed:multiServer.isOnline?@"MultiOnline":@"MultiOffline"]];
    [_switchBtn setHidden:!_multiServer.isOnline];
    
    //显示最新收到的消息
    LDMessageModel *recentMessage = [multiServer recentMessage];
    if (recentMessage != nil) {
        [_message setText:recentMessage.message];
        [_message setTextColor:[UIColor blackColor]];
    }else{
        [_message setText:@"还未收到离线消息"];
        [_message setTextColor:[UIColor lightGrayColor]];
    }
    if (_onlineStatus) {
        [multiServer moniterMessage:^(LDMessageModel *message) {
            [_message setText:message.message];
            [_message setTextColor:[UIColor blackColor]];
        }];
    }
    
    //监听异地登录
    [multiServer moniterPresent:^{
        [_onlineStatus setImage:[UIImage imageNamed:_multiServer.isOnline?@"MultiOnline":@"MultiOffline"]];
        [_switchBtn setHidden:!_multiServer.isOnline];
    }];
}

- (void)exitLogin:(void (^) (bool success))result
{
    [_multiServer logoff:^(NSError *error) {
        result(error == nil);
        [_onlineStatus setImage:[UIImage imageNamed:_multiServer.isOnline?@"MultiOnline":@"MultiOffline"]];
        [_switchBtn setHidden:!_multiServer.isOnline];
    }];
}

- (void)loginWithPassword:(NSString*)password
{
    //登录前动画
    [_onlineStatus setImage:[UIImage imageNamed:@"MultiOnline"]];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2);
        [_onlineStatus setTransform:transform];
    } completion: nil];
    
    //通过密码登录
    [_multiServer autoLoginWithPassword:password completion:^(NSError *error) {
        if (!error) {
            [[LDClient sharedInstance] bindMultiServer:@[_multiServer]];
        }
        [_onlineStatus setImage:[UIImage imageNamed:_multiServer.isOnline?@"MultiOnline":@"MultiOffline"]];
        [_switchBtn setHidden:!_multiServer.isOnline];
//        [_onlineStatus.layer removeAllAnimations];
    }];
}

- (void)multiServerLogin
{
//    [_multiServer autoLogin:^(NSError *error) {
//        if (!error) {
//            [[LDClient sharedInstance] bindMultiServer:@[_multiServer]];
//        }else{
//            LDMultiServerModel *multiServer = [[LDMultiServerModel alloc] initWithCachePath:@"multi"];
//            [multiServer loginWithAccount:@"15289382683"
//                                 password:@"lile1250124009"
//                                loginType:user_type_phone
//                                   region:@"0086"
//                                   domain:@"im" completion:^(NSError *error) {
//                                       if (!error) {
//                                           [[LDClient sharedInstance] bindMultiServer:@[multiServer]];
//                                       }
//                                       [_onlineStatus setImage:[UIImage imageNamed:_multiServer.isOnline?@"MultiOnline":@"MultiOffline"]];
//                                       [_switchBtn setHidden:!_multiServer.isOnline];
//                                       [_onlineStatus.layer removeAllAnimations];
//                                   }];
//            
//        }
//    }];
    
//    NSArray *multiServers = [[LDClient sharedInstance] multiServerInfo];
//    if (multiServers.count > 0) {
//        LDMultiServerModel *multiServer = multiServers[0];
//        [multiServer autoLogin:^(NSError *error) {
//            if (error) {
//                LDMultiServerModel *multiServer = [[LDMultiServerModel alloc] initWithCachePath:@"multi"];
//                [multiServer loginWithAccount:@"15289382683"
//                                     password:@"lile1250124009"
//                                    loginType:user_type_phone
//                                       region:@"0086"
//                                       domain:@"im" completion:^(NSError *error) {
//                                           [[LDClient sharedInstance] bindMultiServer:@[multiServer]];
//                                       }];
//            }else{
//                [[LDClient sharedInstance] bindMultiServer:@[multiServer]];
//            }
//        }];
//    }else{
//        LDMultiServerModel *multiServer = [[LDMultiServerModel alloc] initWithCachePath:@"multi"];
//        [multiServer loginWithAccount:@"15289382683"
//                             password:@"lile1250124009"
//                            loginType:user_type_phone
//                               region:@"0086"
//                               domain:@"im" completion:^(NSError *error) {
//                                   [[LDClient sharedInstance] bindMultiServer:@[multiServer]];
//                               }];
//    }
}

@end
