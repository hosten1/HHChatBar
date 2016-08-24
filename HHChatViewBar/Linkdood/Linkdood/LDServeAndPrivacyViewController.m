//
//  LDServeAndPrivacyViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/1/6.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "LDServeAndPrivacyViewController.h"

@interface LDServeAndPrivacyViewController ()

@end

@implementation LDServeAndPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(_judge == 1?@"服务条款":@"隐私政策", @"")];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_judge == 1?@"serviceTerms":@"privacyPolicy" ofType:@".docx"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=%f, minimum-scale=0.2, maximum-scale=5.0, user-scalable=no\"", webView.scrollView.contentSize.width,SCREEN_SIZE.width/webView.scrollView.contentSize.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}
@end
