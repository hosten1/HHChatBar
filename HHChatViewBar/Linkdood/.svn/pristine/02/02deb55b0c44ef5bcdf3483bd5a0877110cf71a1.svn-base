//
//  UIImageView+DimensionCode.m
//  Linkdood
//
//  Created by renxin on 16/6/28.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "UIImageView+DimensionCode.h"
//#import "KMQRCode.h"
@implementation UIImageView (DimensionCode)
- (UIImage *)qrString:(NSString *)qrString iconImage:(UIImage *)imgIcon{
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    //Value必须传入数据流
    [filter setValue:[qrString dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    
    CIImage *ciImg=filter.outputImage;
    //放大ciImg,默认生产的图片很小
    
    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter=[CIFilter filterWithName:@"CIFalseColor"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    //5.3获取生存的图片
    ciImg=colorFilter.outputImage;
    CGAffineTransform scale=CGAffineTransformMakeScale(10, 10);
    ciImg=[ciImg imageByApplyingTransform:scale];
    //6.在中心增加一张图片
    UIImage *img=[UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    //7.2将二维码的图片画入
    //BSXPCMessage received error for message: Connection interrupted   why??
    [img drawInRect:CGRectMake(-5, 0, img.size.width, img.size.height)];
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    //使用核心绘图框架CG（Core Graphics）对象操作，创建带圆角效果的图片
    //使用核心绘图框架CG（Core Graphics）对象操作，合并二维码图片和用于中间显示的图标图片
//    finalImg = [KMQRCode addIconToQRCodeImage:finalImg
//                                     withIcon:imgIcon
//                                 withIconSize:imgIcon.size];
//    //设置图片
    
    imageView.image = finalImg;
    return imageView.image;
}
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
