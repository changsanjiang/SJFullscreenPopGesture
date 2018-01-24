//
//  WebViewController.m
//  SJBackGRProject
//
//  Created by BlueDancer on 2018/1/23.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "WebViewController.h"
#import <Masonry.h>
#import <WebKit/WebKit.h>
#import "UIViewController+SJVideoPlayerAdd.h"

@interface WebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http:www.baidu.com"]]];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.offset(0);
        make.bottom.offset(-44);
    }];
    
    
    // pop gesture need considers the Web view.
    self.sj_considerWebView = self.webView;
    
}

@end
