//
//  NoNavViewController.m
//  SJBackGR
//
//  Created by BlueDancer on 2017/9/27.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "NoNavViewController.h"
#import "NextViewController.h"
#import "UINavigationController+SJVideoPlayerAdd.h"
#import "UIViewController+SJVideoPlayerAdd.h"
#import "NavigationController.h"

@interface NoNavViewController ()

@property (nonatomic, strong) UIButton *pushBtn;

@property (nonatomic, strong) UIButton *modalBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation NoNavViewController

- (void)dealloc {
    NSLog(@"%s - %zd", __func__, __LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                green:1.0 * (arc4random() % 256 / 255.0)
                                                 blue:1.0 * (arc4random() % 256 / 255.0)
                                                alpha:1];
    
    self.pushBtn = [UIButton new];
    [_pushBtn setTitle:@"Push" forState:UIControlStateNormal];
    [_pushBtn addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_pushBtn];
    _pushBtn.bounds = CGRectMake(0, 0, 100, 50);
    _pushBtn.center = self.view.center;
    
    
    self.sj_viewWillBeginDragging = ^(UIViewController *vc) {
        NSLog(@"begin");
    };
    
    self.sj_viewDidDrag = ^(UIViewController *vc) {
        NSLog(@"dragging");
    };
    
    self.sj_viewDidEndDragging = ^(UIViewController *vc) {
        NSLog(@"end");
    };
    
    self.modalBtn = [UIButton new];
    [_modalBtn setTitle:@"Modal" forState:UIControlStateNormal];
    [_modalBtn addTarget:self action:@selector(presentNextVC) forControlEvents:UIControlEventTouchUpInside];
    [_modalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_modalBtn];
    _modalBtn.bounds = CGRectMake(0, 0, 100, 50);
    CGRect frame = _pushBtn.frame;
    frame.origin.y += 100;
    _modalBtn.frame = frame;
    
    
    self.closeBtn = [UIButton new];
    [_closeBtn setTitle:@"close" forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_closeBtn];
    _closeBtn.bounds = CGRectMake(0, 0, 100, 50);
    frame = _modalBtn.frame;
    frame.origin.y += 100;
    _closeBtn.frame = frame;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"modal_close" style:UIBarButtonItemStyleDone target:self action:@selector(clickedCloseItem)];
}

- (IBAction)pushNextVC:(id)sender {
    if ( !self.navigationController ) {
        NSLog(@"没有导航控制器. 现在跳不了");
        return;
    }
    
    NextViewController * vc = [NextViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentNextVC {
    NextViewController *vc = [NextViewController new];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickedCloseItem {
    NSLog(@"仅对 modal 有效");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
