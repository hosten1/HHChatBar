//
//  LDWebsiteViewController.h
//  Linkdood
//
//  Created by renxin-.- on 16/3/23.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDWebsiteViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *copyright;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong,nonatomic) NSString *urlStr;
@property (assign,nonatomic) BOOL hiddenNavBar;
@end
