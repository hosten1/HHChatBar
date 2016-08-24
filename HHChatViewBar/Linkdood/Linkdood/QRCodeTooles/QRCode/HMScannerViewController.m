//
//  HMScannerViewController.m
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMScannerViewController.h"
#import "HMScannerBorder.h"
#import "HMScannerMaskView.h"
#import "HMScanner.h"

/// 控件间距
#define kControlMargin  32.0

@interface HMScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/// 名片字符串
@property (nonatomic) NSString *cardName;
/// 头像图片
@property (nonatomic) UIImage *avatar;
//扫面的图片
@property (nonatomic) UIImageView *scanimageView;
/// 完成回调
@property (nonatomic, copy) void (^completionCallBack)(NSString *);
@end

@implementation HMScannerViewController {
    /// 扫描框
    HMScannerBorder *scannerBorder;
    /// 扫描器
    HMScanner *scanner;
    /// 提示标签
    UILabel *tipLabel;
}

- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        self.cardName = cardName;
        self.avatar = avatar;
        self.completionCallBack = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    // 实例化扫描器
    __weak typeof(self) weakSelf = self;
    scanner = [HMScanner scanerWithView:self.view scanFrame:scannerBorder.frame completion:^(NSString *stringValue) {
        // 完成回调
        weakSelf.completionCallBack(stringValue);
        
        // 关闭
        [weakSelf clickCloseButton];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.scanimageView.image) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 扫描图像
            [HMScanner scaneImage:self.scanimageView.image completion:^(NSArray *values) {
                
                if (values.count > 0) {
                    self.completionCallBack(values.firstObject);
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self clickCloseButton];
                    }];
                } else {
                    tipLabel.text = @"没有识别到二维码，请选择其他照片";
                    
                }
            }];
            
        });
        
    }
    [scannerBorder startScannerAnimating];
    [scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [scannerBorder stopScannerAnimating];
    [scanner stopScan];
}

#pragma mark - 监听方法
/// 点击关闭按钮
- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 点击相册按钮
- (void)clickAlbumButton {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        tipLabel.text = @"无法访问相册";
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.view.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    
    [self showDetailViewController:picker sender:nil];
}

/// 点击名片按钮
- (void)clickCardButton {
//    HMScanerCardViewController *vc = [[HMScanerCardViewController alloc] initWithCardName:self.cardName avatar:self.avatar];
//    
//    [self showViewController:vc sender:nil];
    if (self.myQRbackButtonClick) {
        self.myQRbackButtonClick(self.navigationController);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.scanimageView.hidden = NO;
    self.scanimageView.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 设置界面
- (void)prepareUI {
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self prepareNavigationBar];
    [self prepareScanerBorder];
    [self prepareOtherControls];
}

/// 准备提示标签和名片按钮
- (void)prepareOtherControls {
    
    //  提示标签
    tipLabel = [[UILabel alloc] init];
    
    tipLabel.text = @"将二维码/条码放入框中，即可自动扫描";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(scannerBorder.center.x, CGRectGetMaxY(scannerBorder.frame) + kControlMargin);
    
    [self.view addSubview:tipLabel];
    // 扫描图片
    _scanimageView = [[UIImageView alloc]init];
    _scanimageView.frame = scannerBorder.frame;
    [self.view addSubview:_scanimageView];
    _scanimageView.hidden = YES;
    [self.view bringSubviewToFront:scannerBorder];
    //    _scanimageView.backgroundColor = [UIColor redColor];
    //  名片按钮
    UIButton *cardButton = [[UIButton alloc] init];
    
    [cardButton setTitle:@"我的名片" forState:UIControlStateNormal];
    cardButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cardButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    
    [cardButton sizeToFit];
    cardButton.center = CGPointMake(tipLabel.center.x, CGRectGetMaxY(tipLabel.frame) + kControlMargin);
    
    [self.view addSubview:cardButton];
    
    [cardButton addTarget:self action:@selector(clickCardButton) forControlEvents:UIControlEventTouchUpInside];
}

/// 准备扫描框
- (void)prepareScanerBorder {
    
    CGFloat width = self.view.bounds.size.width - 80;
    scannerBorder = [[HMScannerBorder alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    
    scannerBorder.center = self.view.center;
    scannerBorder.tintColor = self.navigationController.navigationBar.tintColor;
    
    [self.view addSubview:scannerBorder];
    
    HMScannerMaskView *maskView = [HMScannerMaskView maskViewWithFrame:self.view.bounds cropRect:scannerBorder.frame];
    [self.view insertSubview:maskView atIndex:0];
}

/// 准备导航栏
- (void)prepareNavigationBar {
    // 1> 背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.1 alpha:1.0]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    // 2> 标题
    self.title = @"扫一扫";
    
    // 3> 左右按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(clickAlbumButton)];
}

@end
