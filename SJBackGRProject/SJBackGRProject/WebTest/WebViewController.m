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
#import <SJUIFactory.h>

@interface WebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *forwardBtn;
@property (nonatomic, strong) UIButton *itemListBtn;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http:www.baidu.com"]]];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.offset(0);
        make.bottom.offset(-44);
    }];
    
    
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.itemListBtn];
    [self.view addSubview:self.forwardBtn];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.offset(0);
        make.width.offset(44);
    }];
    
    [_itemListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(0);
    }];
    
    [_forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.offset(0);
        make.width.offset(44);
    }];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)clickedBackBtn:(UIButton *)btn {
    [_webView goBack];
}

- (void)clickedItemListBtn {
    NSLog(@" \n%@ \n- \n%@", _webView.backForwardList.backList, _webView.backForwardList.forwardList);
}

- (void)clickedForwardBtn:(UIButton *)btn {
    [_webView goForward];
}

- (UIButton *)backBtn {
    if ( _backBtn ) return _backBtn;
    _backBtn = [SJUIButtonFactory buttonWithTitle:@"<<" titleColor:[UIColor blueColor] font:[UIFont systemFontOfSize:14] target:self sel:@selector(clickedBackBtn:)];
    return _backBtn;
}

- (UIButton *)itemListBtn {
    if ( _itemListBtn ) return _itemListBtn;
    _itemListBtn = [SJUIButtonFactory buttonWithTitle:@"ItemList" titleColor:[UIColor blueColor] font:[UIFont systemFontOfSize:14] target:self sel:@selector(clickedItemListBtn)];
    return _itemListBtn;
}

- (UIButton *)forwardBtn {
    if ( _forwardBtn ) return _forwardBtn;
    _forwardBtn = [SJUIButtonFactory buttonWithTitle:@">>" titleColor:[UIColor blueColor] font:[UIFont systemFontOfSize:14] target:self sel:@selector(clickedForwardBtn:)];
    return _forwardBtn;
}

@end
