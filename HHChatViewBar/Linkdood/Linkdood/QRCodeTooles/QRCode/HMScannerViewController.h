//
//  HMScannerViewController.h
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyQRbackButtonClick)(UINavigationController *naviController);
/// 扫描控制器
@interface HMScannerViewController : UIViewController
@property (copy,nonatomic) MyQRbackButtonClick myQRbackButtonClick;
/// 实例化扫描控制器
///
/// @param cardName   名片字符串
/// @param avatar     头像图片
/// @param completion 完成回调
///
/// @return 扫描控制器
- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *stringValue))completion;

@end
