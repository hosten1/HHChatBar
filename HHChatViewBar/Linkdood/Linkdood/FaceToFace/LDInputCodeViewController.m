//
//  LDInputCodeViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/8/9.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDInputCodeViewController.h"
#import "LDAddNearbyBuddyCollectionController.h"

@interface LDInputCodeViewController ()<UITextFieldDelegate>
@property (strong, nonatomic)  UIView *cancleView;
@property (strong, nonatomic)  UIButton *zeroBtn;
@property (strong, nonatomic)  UIButton *cancleBtn;
@property (strong, nonatomic)  UILabel *titleLable;

@property (strong, nonatomic)  UIView *numbarPadView;
@property (strong, nonatomic)  UITextField *inputCodeTextFiled;
@property (strong, nonatomic) UIView *padView;

@property (copy, nonatomic) NSMutableString *inputString;
@end

@implementation LDInputCodeViewController
-(instancetype)initWithLocation:(CLLocation *)location{
    if (self == [super init]) {
        self.locationCornor = location;
    }
    return self;
}
-(NSMutableString *)inputString{
    if (!_inputString) {
        _inputString = [NSMutableString string];
    }
    return _inputString;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.inputCodeTextFiled.text = @"";
    self.inputString = nil;
}

-(UIView *)padView{
    if (!_padView) {
        self.cancleView = [[UIView alloc]init];
//        [self.view addSubview:self.cancleView];
        self.titleLable = [[UILabel alloc]init];
        [self.view addSubview:self.titleLable];
        self.titleLable.text = @"请输入和周围人相同的的房间码，进入房间";
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.font = [UIFont systemFontOfSize:14];
        self.titleLable.textColor = [UIColor whiteColor];
        self. inputCodeTextFiled = [[UITextField alloc]init];
        self.inputCodeTextFiled.textColor = [UIColor whiteColor];
        self. inputCodeTextFiled.backgroundColor = [UIColor clearColor];
        self. inputCodeTextFiled.delegate = self;
        [self.view addSubview: self.inputCodeTextFiled];
        self.inputCodeTextFiled.layer.borderWidth = 2;
        self.inputCodeTextFiled.layer.borderColor = [UIColor whiteColor].CGColor;
        self.numbarPadView = [[UIView alloc]init];
        [self.view addSubview:self.numbarPadView];
        UIView *padView = [[UIView alloc]init];
        _padView = padView;
        CGFloat padviewX = 10;
        CGFloat padViewWidth = SCREEN_WIDTH - padviewX*2;
    
        self.titleLable.frame = CGRectMake(0, 10, SCREEN_WIDTH, 30);
        CGFloat x = (SCREEN_WIDTH - 200)/2;
        self.inputCodeTextFiled.frame = CGRectMake(x, CGRectGetMaxY(self.titleLable.frame)+10, 200,40);
        CGFloat padViewY = CGRectGetMaxY(self.inputCodeTextFiled.frame);
        CGFloat padViewHeight = SCREEN_HEIGHT - padViewY-50;
        padView.frame = CGRectMake(padviewX, 0 ,padViewWidth, padViewHeight);
        self.numbarPadView.frame = CGRectMake(0, padViewY+5, SCREEN_WIDTH,padViewHeight);
        [self.numbarPadView addSubview:padView];
        self.cancleView.frame = CGRectMake(0, CGRectGetMaxY(self.numbarPadView.frame), SCREEN_WIDTH, 50);

    }
    return _padView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isGroup) {
         self.view.backgroundColor = [UIColor colorWithRed:0.295 green:0.409 blue:1.000 alpha:1.000];
    }else{
         self.view.backgroundColor = [UIColor colorWithRed:0.272 green:0.773 blue:1.000 alpha:1.000];
    }
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self addNumberPad];
    [self.inputCodeTextFiled setTextColor:[UIColor orangeColor]];
    UIView *leftVView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.inputCodeTextFiled.leftView = leftVView;
    self.inputCodeTextFiled.leftViewMode = UITextFieldViewModeAlways;
    //有用户退出房间
    [self.faceToFaceModel userExitedRoom:^(int64_t userID){
        if (userID != 0) {
            //获取退出房间用户的信息
            
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"房主已经解散房间房间"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
        }
    }];

}
-(void)addNumberPad{
    NSInteger count = 12;
    CGFloat subViewWidth = 50;
    CGFloat subViewHight = 50;
    NSInteger rowNum = 3;
    UIButton *btnViews;
    CGFloat marginX = (self.padView.frame.size.width-rowNum*subViewWidth)/(rowNum+1);
    for (int i=0; i<count; i++) {
        btnViews = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 10) {
            btnViews.hidden = YES;
        }
        [_padView addSubview:btnViews];
        
        int row = i/rowNum;
        int col = i%rowNum;
        CGFloat subViewY;
        CGFloat subViewX;
        subViewX = marginX+(marginX+subViewWidth)*col;
        subViewY = marginX+(marginX+subViewHight)*row;
        [btnViews setFrame:CGRectMake(subViewX, subViewY, subViewWidth, subViewHight)];
        btnViews.tag = 201689+i;
        if (i<9) {
            [btnViews setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [btnViews setBackgroundImage:[UIImage imageNamed:@"number_faceToface"] forState:UIControlStateNormal];
            [btnViews setBackgroundImage:[UIImage imageNamed:@"number_faceToface_select"] forState:UIControlStateSelected];
        }else{
            if (i == 9) {
                [btnViews setTitle:[NSString stringWithFormat:@"%d",0] forState:UIControlStateNormal];
                [btnViews setBackgroundImage:[UIImage imageNamed:@"number_faceToface"] forState:UIControlStateNormal];
                [btnViews setBackgroundImage:[UIImage imageNamed:@"number_faceToface_select"] forState:UIControlStateSelected];
            }else{
                self.cancleBtn = btnViews;
                [btnViews setBackgroundImage:[UIImage imageNamed:@"delete_facetoface"] forState:UIControlStateNormal];
                [btnViews setBackgroundImage:[UIImage imageNamed:@"delete_facetoface_select"] forState:UIControlStateSelected];
                btnViews.selected = YES;
                btnViews.userInteractionEnabled = NO;

            }
        }
       
        [btnViews addTarget:self action:@selector(subViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnViews setBackgroundColor:[UIColor clearColor]];
    }
}
#pragma mark -- 九宫格数字键盘响应
-(void)subViewButtonClick:(id)sender{
    if ([self.inputCodeTextFiled.text length] > 1) {
        self.cancleBtn.selected = NO;
        self.cancleBtn.userInteractionEnabled = YES;
    }else{
        self.cancleBtn.selected = YES;
        self.cancleBtn.userInteractionEnabled = NO;
    }
    UIButton *btn = (UIButton *)sender;
    NSString *btnString;
    switch (btn.tag) {
        case (201689+11):
            btnString = [self.inputString substringToIndex:[self.inputString length] - 1];
            [self.inputString deleteCharactersInRange:NSMakeRange([self.inputString length] - 1, 1)];
//            [self.inputCodeTextFiled deleteBackward];
            break;
            
        default:
            if (self.inputCodeTextFiled.text.length == 6) {
                self.inputString=nil;
                break;
            }
            [self.inputString appendString:btn.titleLabel.text];
            btnString  = self.inputString;
            break;
    }
    self.inputCodeTextFiled.text = btnString;
    if (self.inputCodeTextFiled.text.length == 6) {
        self.cancleBtn.selected = YES;
        if (self.locationCornor) {
        if (self.isGroup) {
            [self.faceToFaceModel joinGroupRoomWithLocation:self.locationCornor password:self.inputCodeTextFiled.text completion:^(NSError *error, NSArray<LDUserModel *> *users) {
                if (!error) {
                    LDAddNearbyBuddyCollectionController *nearbyAdd = [[LDAddNearbyBuddyCollectionController alloc]init];
                    if (nearbyAdd.fromValueBlock) {
                        nearbyAdd.fromValueBlock(1,self.faceToFaceModel,self.isGroup,self.nc);
                    }
                    [self.nc pushViewController:nearbyAdd animated:YES];
                }else{
//                    if (self.inputString.length != 0) {
//                        self.inputString = nil;
//                    }
                    
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                }
            }];
        }else{
            [self.faceToFaceModel joinBuddyRoomWithLocation:self.locationCornor password:self.inputCodeTextFiled.text completion:^(NSError *error, NSArray<LDUserModel *> *users) {
                if (!error) {
                    LDAddNearbyBuddyCollectionController *nearbyAdd = [[LDAddNearbyBuddyCollectionController alloc]init];
                    if (nearbyAdd.fromValueBlock) {
                        nearbyAdd.fromValueBlock(1,self.faceToFaceModel,self.isGroup,self.nc);
                    }
                    [self.nc pushViewController:nearbyAdd animated:YES];
                }else{
//                    if (self.inputString.length != 0) {
//                        self.inputString = nil;
//                    }
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                }
               
            }];
        }
        
    }
    
        return;
    }else{
        self.cancleBtn.selected = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cancleBtnCllick:(id)sender {
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
@end
