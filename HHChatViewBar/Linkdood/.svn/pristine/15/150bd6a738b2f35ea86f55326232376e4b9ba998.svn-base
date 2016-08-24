//
//  LDWebsiteViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/23.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDWebsiteViewController.h"

@interface LDWebsiteViewController ()
@property (nonatomic,strong) UIView *statusView;

@end

@implementation LDWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _urlStr = @"http://vrv.linkdood.cn";
    if (_hiddenNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        _statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        _statusView.backgroundColor = RGBACOLOR(18, 139, 210, 0.8);
    }
    _copyright.delegate = self;
    [_copyright.scrollView setShowsHorizontalScrollIndicator:NO];
    [_copyright.scrollView setShowsVerticalScrollIndicator:NO];
    [_copyright loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    
}

- (void) viewWillAppear: (BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_hiddenNavBar) {
        [_statusView removeFromSuperview];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString *urlString = [url absoluteString];
    if ([urlString isEqualToString:@"ios:back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [_copyright setHidden:YES];
    [_activity setHidden:NO];
    [_activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_hiddenNavBar) {
        [APP_WINDOW addSubview:_statusView];
    }
    [_copyright setHidden:NO];
    [_activity stopAnimating];
    [_activity setHidden:YES];
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=%f, minimum-scale=0.2, maximum-scale=5.0, user-scalable=yes\"", webView.scrollView.contentSize.width,SCREEN_SIZE.width/webView.scrollView.contentSize.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    [self addTipStr];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_hiddenNavBar) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [_activity stopAnimating];
    [_activity setHidden:YES];
}

- (void)addTipStr{
    NSMutableString *str = [[NSMutableString alloc]initWithString:_urlStr];
    
    NSRange range1,range2;
    range1 = [str rangeOfString:@"http://"];
    if (range1.location != NSNotFound) {
        [str deleteCharactersInRange:range1];
    }
    range2 = [str rangeOfString:@"https://"];
    if (range2.location != NSNotFound) {
        [str deleteCharactersInRange:range2];
    }
    str = [[NSMutableString alloc]initWithString:[[str componentsSeparatedByString:@"/"]objectAtIndex:0]];
    
    NSMutableString *tipStr = [[NSMutableString alloc]initWithFormat:NSLocalizedString(@"vrv.linkdood.cn", nil),str];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 42)];
    label.backgroundColor = [UIColor clearColor];;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = tipStr;
    label.textAlignment = NSTextAlignmentCenter;
    [_copyright insertSubview:label atIndex:0];
}

- (UILabel*)labelWithFrame:(CGRect)frame
                 textColor:(UIColor*)color
                      font:(UIFont*)font
                   context:(NSString*)context
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = font;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = context;
    
    return label;
}

@end
