//
//  HMScannerController.m
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMScannerController.h"
#import "HMScannerViewController.h"
#import "HMScanner.h"

@interface HMScannerController ()
@property(nonatomic,strong)HMScannerViewController *scanner;
@end

@implementation HMScannerController

+ (void)cardImageWithCardName:(NSString*)qrString avatar:(UIImage*)avatar contentSize:(CGFloat)contentSize completion:(void (^)(UIImage *))completion{
    [HMScanner qrImageWithString:qrString avatar:avatar contentSize:contentSize completion:completion];
}

+ (instancetype)scannerWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    NSAssert(completion != nil, @"必须传入完成回调");
    return [[self alloc] initWithCardName:cardName avatar:avatar completion:completion];
}

- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        HMScannerViewController *scanner = [[HMScannerViewController alloc] initWithCardName:cardName avatar:avatar completion:completion];
        self.scanner = scanner;
        [self setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
        
        [self pushViewController:scanner animated:NO];
    }
    return self;
}
-(void)resopnserToMyCardWithMyQRbackButtonClick:(MyQRbackButtonClick)myQRbackButtonClick{
  
    if (myQRbackButtonClick) {
        self.scanner.myQRbackButtonClick = ^(UINavigationController *naviController){
            myQRbackButtonClick(naviController);
        };
    }
}
- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor}];
    self.navigationBar.tintColor = tintColor;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
