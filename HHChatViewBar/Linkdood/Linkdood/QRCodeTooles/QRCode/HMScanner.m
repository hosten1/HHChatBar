//
//  HMScanner.m
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMScanner.h"
#import <AVFoundation/AVFoundation.h>

/// 最大检测次数
#define kMaxDetectedCount   20

@interface HMScanner() <AVCaptureMetadataOutputObjectsDelegate>
/// 父视图弱引用
@property (nonatomic, weak) UIView *parentView;
/// 扫描范围
@property (nonatomic) CGRect scanFrame;
/// 完成回调
@property (nonatomic, copy) void (^completionCallBack)(NSString *);
@end

@implementation HMScanner {
    /// 拍摄会话
    AVCaptureSession *session;
    /// 预览图层
    AVCaptureVideoPreviewLayer *previewLayer;
    /// 绘制图层
    CALayer *drawLayer;
    /// 当前检测计数
    NSInteger currentDetectedCount;
}

#pragma mark - 生成二维码
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar completion:(void (^)(UIImage *))completion {
    [self qrImageWithString:string avatar:avatar contentSize:1000.0f completion:completion];
}

+ (void)qrImageWithString:(NSString *)qrString avatar:(UIImage *)avatar contentSize:(CGFloat)contentSize completion:(void (^)(UIImage *))completion {
    __block CGFloat contentsize = contentSize;
    NSAssert(completion != nil, @"必须传入完成回调");
    if (!qrString || (NSNull *)qrString == [NSNull null]) { return ; }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        /** 颜色不可以太接近白色*/
//        NSUInteger rgb = (red << 16) + (green << 8) + blue;
//        NSAssert((rgb & 0xffffff00) <= 0xd0d0d000, @"The color of QR code is two close to white color than it will diffculty to scan");
        contentsize = [self validateCodeSize:contentsize];
        
        CIImage * originImage = [self createQRFromAddress: qrString];
        UIImage * progressImage = [self excludeFuzzyImageFromCIImage:originImage size:contentsize];
        
        UIImage * effectiveImage = [self imageFillBlackColorAndTransparent: progressImage red:0 green:0 blue:0];
        
        UIImage *qrImage = [self imageInsertedImage: effectiveImage insertImage: avatar radius:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{ completion(qrImage); });
    });
}
#pragma mark - private
/*!
 * @function ProviderReleaseData
 *
 * @abstract
 * 回调函数
 */
void ProviderReleaseData(void * info, const void * data, size_t size) {
    free((void *)data);
}

/**
 *  控制二维码尺寸在合适的范围内
 */
+ (CGFloat)validateCodeSize: (CGFloat)codeSize
{
    codeSize = MAX(160, codeSize);
    codeSize = MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - 80, codeSize);
    return codeSize;
}

/*!
 * @function createQRFromAddress:
 *
 * @abstract
 * 通过链接地址生成原生的二维码图（由于大小不好控制，需要加工）
 */
+ (CIImage *)createQRFromAddress: (NSString *)networkAddress
{
    NSData * stringData = [networkAddress dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter * qrFilter = [CIFilter filterWithName: @"CIQRCodeGenerator"];
    [qrFilter setValue: stringData forKey: @"inputMessage"];
    [qrFilter setValue: @"H" forKey: @"inputCorrectionLevel"];
    
    return qrFilter.outputImage;
}

/*!
 * @function createNonInterpolatedImageFromCIImage: size:
 *
 * @abstract
 * 对生成的原始二维码进行加工，返回大小适合的黑白二维码图。因此还需要进行颜色填充
 */
+ (UIImage *)excludeFuzzyImageFromCIImage: (CIImage *)image size: (CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    //创建灰度色调空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage: scaledImage];
}

/*!
 * @function imageFillBlackColorToTransparent: red: green: blue:
 *
 * @abstract
 * 对加工过的黑白二维码进行颜色填充，并转换成透明背景
 */
+ (UIImage *)imageFillBlackColorAndTransparent: (UIImage *)image red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    
    //遍历像素
    int pixelNumber = imageHeight * imageWidth;
    [self fillWhiteToTransparentOnPixel: rgbImageBuf pixelNum: pixelNumber red: red green: green blue: blue];
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return resultImage;
}

/*!
 * @function fillWhiteToTransparentOnPixel: pixelNum: red: green: blue:
 *
 * @abstract
 * 遍历所有像素点，将白色区域填充为透明色
 */
+ (void)fillWhiteToTransparentOnPixel: (uint32_t *)rgbImageBuf pixelNum: (int)pixelNum red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue
{
    uint32_t * pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xffffff00) < 0x99999900) {
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        }
        else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
}

/*!
 * @function imageInsertedImage: insertImage:
 *
 * @abstract
 * 在渲染后的二维码图上进行图片插入，如插入图为空，直接返回二维码图
 */
+ (UIImage *)imageInsertedImage: (UIImage *)originImage insertImage: (UIImage *)insertImage radius: (CGFloat)radius
{
    if (!insertImage) { return originImage; }
//    insertImage = [UIImage imageOfRoundRectWithImage: insertImage size: insertImage.size radius: radius];
    UIImage * whiteBG = [UIImage imageNamed: @"whiteBG"];
//    whiteBG = [UIImage imageOfRoundRectWithImage: whiteBG size: whiteBG.size radius: radius];
    
    //白色边缘宽度
    const CGFloat whiteSize = 5.f;
    CGSize brinkSize = CGSizeMake(originImage.size.width / 4, originImage.size.height / 4);
    CGFloat brinkX = (originImage.size.width - brinkSize.width) * 0.5;
    CGFloat brinkY = (originImage.size.height - brinkSize.height) * 0.5;
    
    CGSize imageSize = CGSizeMake(brinkSize.width - 2 * whiteSize, brinkSize.height - 2 * whiteSize);
    CGFloat imageX = brinkX + whiteSize;
    CGFloat imageY = brinkY + whiteSize;
    
    UIGraphicsBeginImageContext(originImage.size);
    [originImage drawInRect: (CGRect){ 0, 0, (originImage.size) }];
    [whiteBG drawInRect: (CGRect){ brinkX, brinkY, (brinkSize) }];
    [insertImage drawInRect: (CGRect){ imageX, imageY, (imageSize) }];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}


#pragma mark - 扫描图像方法
+ (void)scaneImage:(UIImage *)image completion:(void (^)(NSArray *))completion {
    
    NSAssert(completion != nil, @"必须传入完成回调");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        
        NSArray *features = [detector featuresInImage:ciImage];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:features.count];
        for (CIQRCodeFeature *feature in features) {
            [arrayM addObject:feature.messageString];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(arrayM.copy);
        });
    });
}

#pragma mark - 构造函数
+ (instancetype)scanerWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *))completion {
    NSAssert(completion != nil, @"必须传入完成回调");
    
    return [[self alloc] initWithView:view scanFrame:scanFrame completion:completion];
}

- (instancetype)initWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *))completion {
    self = [super init];
    
    if (self) {
        self.parentView = view;
        self.scanFrame = scanFrame;
        self.completionCallBack = completion;
        
        [self setupSession];
    }
    return self;
}

#pragma mark - 公共方法
/// 开始扫描
- (void)startScan {
    if ([session isRunning]) {
        return;
    }
    currentDetectedCount = 0;
    
    [session startRunning];
}

- (void)stopScan {
    if (![session isRunning]) {
        return;
    }
    [session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    [self clearDrawLayer];
    
    for (id obj in metadataObjects) {
        // 判断检测到的对象类型
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            return;
        }
        
        // 转换对象坐标
        AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *)[previewLayer transformedMetadataObjectForMetadataObject:obj];
        
        // 判断扫描范围
        if (!CGRectContainsRect(self.scanFrame, dataObject.bounds)) {
            continue;
        }
        
        if (currentDetectedCount++ < kMaxDetectedCount) {
            // 绘制边角
            [self drawCornersShape:dataObject];
        } else {
            [self stopScan];
            
            // 完成回调
            if (self.completionCallBack != nil) {
                self.completionCallBack(dataObject.stringValue);
            }
        }
    }
}

/// 清空绘制图层
- (void)clearDrawLayer {
    if (drawLayer.sublayers.count == 0) {
        return;
    }
    
    [drawLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

/// 绘制条码形状
///
/// @param dataObject 识别到的数据对象
- (void)drawCornersShape:(AVMetadataMachineReadableCodeObject *)dataObject {
    
    if (dataObject.corners.count == 0) {
        return;
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = [self cornersPath:dataObject.corners];
    
    [drawLayer addSublayer:layer];
}

/// 使用 corners 数组生成绘制路径
///
/// @param corners corners 数组
///
/// @return 绘制路径
- (CGPathRef)cornersPath:(NSArray *)corners {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    
    // 1. 移动到第一个点
    NSInteger index = 0;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
    [path moveToPoint:point];
    
    // 2. 遍历剩余的点
    while (index < corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
        [path addLineToPoint:point];
    }
    
    // 3. 关闭路径
    [path closePath];
    
    return path.CGPath;
}

#pragma mark - 扫描相关方法
/// 设置绘制图层和预览图层
- (void)setupLayers {
    
    if (self.parentView == nil) {
        NSLog(@"父视图不存在");
        return;
    }
    
    if (session == nil) {
        NSLog(@"拍摄会话不存在");
        return;
    }
    
    // 绘制图层
    drawLayer = [CALayer layer];
    
    drawLayer.frame = self.parentView.bounds;
    
    [self.parentView.layer insertSublayer:drawLayer atIndex:0];
    
    // 预览图层
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.parentView.bounds;
    
    [self.parentView.layer insertSublayer:previewLayer atIndex:0];
}

/// 设置扫描会话
- (void)setupSession {
    
    // 1> 输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (videoInput == nil) {
        NSLog(@"创建输入设备失败");
        return;
    }
    
    // 2> 数据输出
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    // 3> 拍摄会话 - 判断能够添加设备
    session = [[AVCaptureSession alloc] init];
    if (![session canAddInput:videoInput]) {
        NSLog(@"无法添加输入设备");
        session = nil;
        
        return;
    }
    if (![session canAddOutput:dataOutput]) {
        NSLog(@"无法添加输入设备");
        session = nil;
        
        return;
    }
    
    // 4> 添加输入／输出设备
    [session addInput:videoInput];
    [session addOutput:dataOutput];
    
    // 5> 设置扫描类型
    dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes;
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6> 设置预览图层会话
    [self setupLayers];
}

@end
