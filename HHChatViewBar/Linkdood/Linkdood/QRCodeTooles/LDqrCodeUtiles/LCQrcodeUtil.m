//
//  LCQrcodeUtil.m
//  二维码测试
//
//  Created by 刘通超 on 16/5/5.
//  Copyright © 2016年 刘通超. All rights reserved.
//

#import "LCQrcodeUtil.h"

@implementation LCQRCodeUtil

#pragma mark 读取图片二维码
/**
 *  读取图片中二维码信息
 *
 *  @param image 图片
 *
 *  @return 二维码内容
 */
+(NSString *)readQRCodeFromImage:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    CIImage *ciimage = [CIImage imageWithData:data];
    if (ciimage) {
        CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}] options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        NSArray *resultArr = [qrDetector featuresInImage:ciimage];
        if (resultArr.count >0) {
            CIFeature *feature = resultArr[0];
            CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
            NSString *result = qrFeature.messageString;
            
            return result;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
@end
