//
//  LDLoginWelcomeViewController.m
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDLoginWelcomeViewController.h"
#import "LDAuthRegisterTableViewController.h"
#import "AppDelegate.h"

@interface LDLoginWelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@end

@implementation LDLoginWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    if (SCREEN_WIDTH == 320) {
        if (SCREEN_HEIGHT == 480) {
            _backImage.image = [UIImage imageNamed:@"screen640x960"];
        }
        else{
            _backImage.image = [UIImage imageNamed:@"screen640x1136"];
        }
    }
    if (SCREEN_WIDTH == 375) {
        _backImage.image = [UIImage imageNamed:@"screen750x1134"];
    }
    if (SCREEN_WIDTH == 414) {
        _backImage.image = [UIImage imageNamed:@"screen1242x2208"];
    }
    
    
    _login.hidden = YES;
    _registerBtn.hidden = YES;

    [self initView];
}


-(void)initView{
        _login.hidden = NO;
        _registerBtn.hidden = NO;
        
        [_login setTitleColor:RGBACOLOR(5, 139, 224, 1) forState:UIControlStateNormal];
        _login.layer.borderWidth = 1;
        _login.layer.borderColor = [RGBACOLOR(5, 139, 224, 1)CGColor];
        [_login.layer setCornerRadius:2];
        [_registerBtn setTitleColor:RGBACOLOR(5, 139, 224, 1) forState:UIControlStateNormal];
        _registerBtn.layer.borderWidth = 1;
        _registerBtn.layer.borderColor = [RGBACOLOR(5, 139, 224, 1) CGColor];
        [_registerBtn.layer setCornerRadius:2];
}
- (void)fillView
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [(AppDelegate*)SYS_DELEGATE loginSuccessfulCompleteBlock:^{
//            
//        }];
//    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)loginTap:(UIButton *)sender {
    [self performSegueWithIdentifier:@"LDAuthLoginViewController" sender:nil];
}

- (IBAction)registerTap:(UIButton *)sender {
    [self performSegueWithIdentifier:@"LDAuthRegisterTableViewController" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LDAuthRegisterTableViewController"]) {
        LDAuthRegisterTableViewController *auth = segue.destinationViewController;
        auth.authRegister = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
