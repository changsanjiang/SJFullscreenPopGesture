//
//  NextViewController.m
//  SJBackGR
//
//  Created by BlueDancer on 2017/9/26.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "NextViewController.h"
#import "UINavigationController+SJVideoPlayerAdd.h"
#import "UIViewController+SJVideoPlayerAdd.h"
#import "NavigationController.h"

@interface NextViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *pushBtn;

@property (nonatomic, strong) UIButton *modalBtn;

@property (nonatomic, strong, readonly) UIButton *nativeModeBtn;

@property (nonatomic, strong, readonly) UIButton *customModeBtn;

@property (nonatomic, strong, readonly) UIButton *popToRootVCBtn;

@property (nonatomic, strong, readonly) UIButton *popToVCBtn;

@property (nonatomic, strong, readonly) UIScrollView *backgroundScrollView;

@property (nonatomic, strong, readonly) UIView *testPanBackgroundView;

@end

@implementation NextViewController {
    UISegmentedControl *_segmented;
}


@synthesize nativeModeBtn = _nativeModeBtn;
@synthesize customModeBtn = _customModeBtn;
@synthesize popToRootVCBtn = _popToRootVCBtn;
@synthesize popToVCBtn = _popToVCBtn;
@synthesize backgroundScrollView = _backgroundScrollView;
@synthesize testPanBackgroundView = _testPanBackgroundView;

- (void)dealloc {
    NSLog(@"%s - %zd", __func__, __LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                green:1.0 * (arc4random() % 256 / 255.0)
                                                 blue:1.0 * (arc4random() % 256 / 255.0)
                                                alpha:1];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.backgroundScrollView];
    
    self.label = [UILabel new];
    _label.text = @"人生若只如初见，何事秋风悲画扇。";
    [_label sizeToFit];
    _label.center = CGPointMake(self.view.frame.size.width * 0.5, 100);
    [self.view addSubview:_label];
    
    self.testPanBackgroundView.frame = CGRectMake(self.view.frame.size.width * 0.5, 130, 100, 100);
    [self.view addSubview:self.testPanBackgroundView];
    
    
    self.pushBtn = [UIButton new];
    [_pushBtn setTitle:@"Push" forState:UIControlStateNormal];
    [_pushBtn addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_pushBtn];
    _pushBtn.bounds = CGRectMake(0, 0, 100, 50);
    _pushBtn.center = self.view.center;
    
    
    _segmented = [[UISegmentedControl alloc] initWithItems:@[@"Use Custom", @"Use Native"]];
    self.navigationItem.titleView = _segmented;
    
    [_segmented addTarget:self action:@selector(clickedSegmented:) forControlEvents:UIControlEventValueChanged];
    
    
    self.sj_viewWillBeginDragging = ^(UIViewController *vc) {
//        NSLog(@"begin");
    };
    
    self.sj_viewDidDrag = ^(UIViewController *vc) {
//        NSLog(@"dragging");
//        NSLog(@"scMaxOffset = %f", vc.navigationController.scMaxOffset);
    };
    
    self.sj_viewDidEndDragging = ^(UIViewController *vc) {
//        NSLog(@"end");
    };
    
    self.modalBtn = [UIButton new];
    [_modalBtn setTitle:@"Modal" forState:UIControlStateNormal];
    [_modalBtn addTarget:self action:@selector(presentNextVC) forControlEvents:UIControlEventTouchUpInside];
    [_modalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_modalBtn];
    _modalBtn.bounds = CGRectMake(0, 0, 200, 50);
    CGRect frame = _pushBtn.frame;
    frame.origin.y += 50;
    _modalBtn.frame = frame;
    
    
    [self.view addSubview:self.popToRootVCBtn];
    frame.origin.y += 50;
    _popToRootVCBtn.frame = frame;
    
    [self.view addSubview:self.popToVCBtn];
    frame.origin.y += 50;
    _popToVCBtn.frame = frame;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"modalClose" style:UIBarButtonItemStyleDone target:self action:@selector(clickedCloseItem)];
    
    
    self.sj_viewWillBeginDragging = ^(NextViewController *vc) {
        vc.backgroundScrollView.scrollEnabled = NO;
    };
    
    self.sj_viewDidEndDragging = ^(NextViewController *vc) {
        vc.backgroundScrollView.scrollEnabled = YES;
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // update selected index
    _segmented.selectedSegmentIndex = self.navigationController.useNativeGesture;
}

- (void)clickedSegmented:(UISegmentedControl *)control {
    self.navigationController.useNativeGesture = control.selectedSegmentIndex;
}

- (IBAction)pushNextVC:(id)sender {
    NextViewController * vc = [NextViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentNextVC {
    NextViewController *vc = [NextViewController new];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickedCloseItem {
    NSLog(@"-------");
    NSLog(@"仅对 modal 有效");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickedPopToRootVCBtn:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickedPopToVCBtn:(UIButton *)btn {
    NSInteger random = arc4random() % self.navigationController.childViewControllers.count - 1;
    if ( random < 0 ) random = 0;
    [self.navigationController popToViewController:self.navigationController.childViewControllers[random] animated:YES];
}

#pragma mark - Mode

- (void)clickednativeModeBtn:(UIButton *)btn {
    self.navigationController.useNativeGesture = YES;
}

- (UIButton *)nativeModeBtn {
    if ( _nativeModeBtn ) return _nativeModeBtn;
    _nativeModeBtn = [UIButton new];
    [_nativeModeBtn setTitle:@"use native" forState:UIControlStateNormal];
    [_nativeModeBtn sizeToFit];
    [_nativeModeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_nativeModeBtn addTarget:self action:@selector(clickednativeModeBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _nativeModeBtn;
}

- (void)clickedCustomModeBtn:(UIButton *)btn {
    self.navigationController.useNativeGesture = NO;
}

- (UIButton *)customModeBtn {
    if ( _customModeBtn ) return _customModeBtn;
    _customModeBtn = [UIButton new];
    [_customModeBtn setTitle:@"use Custom" forState:UIControlStateNormal];
    [_customModeBtn sizeToFit];
    [_customModeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_customModeBtn addTarget:self action:@selector(clickedCustomModeBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _customModeBtn;
}

- (UIButton *)popToRootVCBtn {
    if ( _popToRootVCBtn ) return _popToRootVCBtn;
    _popToRootVCBtn = [UIButton new];
    [_popToRootVCBtn setTitle:@"PopToRootVC" forState:UIControlStateNormal];
    [_popToRootVCBtn sizeToFit];
    [_popToRootVCBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popToRootVCBtn addTarget:self action:@selector(clickedPopToRootVCBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _popToRootVCBtn;
}

- (UIButton *)popToVCBtn {
    if ( _popToVCBtn ) return _popToVCBtn;
    _popToVCBtn = [UIButton new];
    [_popToVCBtn setTitle:@"PopToVC" forState:UIControlStateNormal];
    [_popToVCBtn sizeToFit];
    [_popToVCBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popToVCBtn addTarget:self action:@selector(clickedPopToVCBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _popToVCBtn;
}

- (UIScrollView *)backgroundScrollView {
    if ( _backgroundScrollView ) return _backgroundScrollView;
    _backgroundScrollView = [UIScrollView new];
    _backgroundScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    int subCount = 5;
    _backgroundScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * subCount, CGRectGetHeight(self.view.frame));
    for ( int i = 0 ; i < subCount ; i ++ ) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                               green:1.0 * (arc4random() % 256 / 255.0)
                                                blue:1.0 * (arc4random() % 256 / 255.0)
                                               alpha:1];
        view.frame = CGRectMake(CGRectGetWidth(self.view.frame) * i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [_backgroundScrollView addSubview:view];
    }
    _backgroundScrollView.pagingEnabled = YES;
    return _backgroundScrollView;
}

- (UIView *)testPanBackgroundView {
    if ( _testPanBackgroundView ) return _testPanBackgroundView;
    _testPanBackgroundView = [UIView new];
    _testPanBackgroundView.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                            green:1.0 * (arc4random() % 256 / 255.0)
                                                             blue:1.0 * (arc4random() % 256 / 255.0)
                                                            alpha:1];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestPan:)];
    [_testPanBackgroundView addGestureRecognizer:pan];
    return _testPanBackgroundView;
}

- (void)handleTestPan:(UIPanGestureRecognizer *)pan {
//    NSLog(@"%zd - %s", __LINE__, __func__);
}

@end
