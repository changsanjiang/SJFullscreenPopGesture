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
#import <SJUIFactory.h>

@interface NextViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *pushBtn;

@property (nonatomic, strong) UIButton *modalBtn;

@property (nonatomic, strong, readonly) UIButton *popToRootVCBtn;

@property (nonatomic, strong, readonly) UIButton *popToVCBtn;

@property (nonatomic, strong, readonly) UIButton *disableBtn;

@property (nonatomic, strong, readonly) UIButton *albumBtn;

@property (nonatomic, strong, readonly) UIScrollView *backgroundScrollView;

@property (nonatomic, strong, readonly) UIView *testPanBackgroundView;

@property (nonatomic, strong, readonly) UIView *testOtherGestureView;

@end

@implementation NextViewController

@synthesize popToRootVCBtn = _popToRootVCBtn;
@synthesize popToVCBtn = _popToVCBtn;
@synthesize backgroundScrollView = _backgroundScrollView;
@synthesize testPanBackgroundView = _testPanBackgroundView;
@synthesize disableBtn = _disableBtn;
@synthesize albumBtn = _albumBtn;
@synthesize testOtherGestureView = _testOtherGestureView;

- (void)dealloc {
    NSLog(@"%s - %zd", __func__, __LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.sj_transitionMode = SJScreenshotTransitionModeShifting;
    self.navigationController.sj_transitionMode = SJScreenshotTransitionModeShadeAndShifting;
    
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
    
    self.testOtherGestureView.frame = CGRectMake(self.view.frame.size.width * 0.5, 250, 100, 100);
    [self.view addSubview:self.testOtherGestureView];
    
    self.pushBtn = [UIButton new];
    [_pushBtn setTitle:@"Push" forState:UIControlStateNormal];
    [_pushBtn addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_pushBtn];
    _pushBtn.bounds = CGRectMake(0, 0, 300, 50);
    _pushBtn.center = self.view.center;
    [_pushBtn sizeToFit];
    
    
    #pragma mark -
    
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
    
    #pragma mark -
    
    self.modalBtn = [UIButton new];
    [_modalBtn setTitle:@"Modal" forState:UIControlStateNormal];
    [_modalBtn addTarget:self action:@selector(presentNextVC) forControlEvents:UIControlEventTouchUpInside];
    [_modalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_modalBtn];
    CGRect frame = _pushBtn.frame;
    frame.origin.y += 30;
    _modalBtn.frame = frame;
    [_modalBtn sizeToFit];
    
    [self.view addSubview:self.popToRootVCBtn];
    frame.origin.y += 30;
    _popToRootVCBtn.frame = frame;
    [_popToRootVCBtn sizeToFit];
    
    [self.view addSubview:self.popToVCBtn];
    frame.origin.y += 30;
    _popToVCBtn.frame = frame;
    [_popToVCBtn sizeToFit];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"modalClose" style:UIBarButtonItemStyleDone target:self action:@selector(clickedCloseItem)];
    
    [self.view addSubview:self.disableBtn];
    frame.origin.y += 30;
    _disableBtn.frame = frame;
    [_disableBtn sizeToFit];
    
    [self.view addSubview:self.albumBtn];
    frame.origin.y += 30;
    _albumBtn.frame = frame;
    [_albumBtn sizeToFit];
    
    
    
    
    #pragma mark - Fade Area
    
    UIView *testFadeAreaView = [UIView new];
    testFadeAreaView.frame = CGRectMake(200, 20, 100, 50);
    testFadeAreaView.backgroundColor = [UIColor orangeColor];
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = @"Test fade area";
    [tipsLabel sizeToFit];
    [testFadeAreaView addSubview:tipsLabel];
    [self.view addSubview:testFadeAreaView];

//    self.sj_fadeArea = @[@(_pushBtn.frame), @(testFadeAreaView.frame)];
    self.sj_fadeAreaViews = @[testFadeAreaView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ( self.sj_DisableGestures ) {
        [_disableBtn setTitle:@"Enable gesture" forState:UIControlStateNormal];
    }
    else {
        [_disableBtn setTitle:@"Disable gesture" forState:UIControlStateNormal];
    }
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

- (void)clickedDisableBtn:(UIButton *)btn {
    self.sj_DisableGestures = !self.sj_DisableGestures;
    if ( self.sj_DisableGestures ) {
        [_disableBtn setTitle:@"Enable gesture" forState:UIControlStateNormal];
    }
    else {
        [_disableBtn setTitle:@"Disable gesture" forState:UIControlStateNormal];
    }
}

- (void)clickedAlbumBtn:(UIButton *)btn {
    [[SJUIImagePickerControllerFactory shared] alterPickerViewControllerWithController:self alertTitle:@"" msg:@"" photoLibrary:^(UIImage *selectedImage) {
        [btn setBackgroundImage:selectedImage forState:UIControlStateNormal];
    } camera:^(UIImage *selectedImage) {
        [btn setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }];
}

#pragma mark - Views

- (UIButton *)popToRootVCBtn {
    if ( _popToRootVCBtn ) return _popToRootVCBtn;
    _popToRootVCBtn = [UIButton new];
    [_popToRootVCBtn setTitle:@"PopToRootVC" forState:UIControlStateNormal];
    [_popToRootVCBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popToRootVCBtn addTarget:self action:@selector(clickedPopToRootVCBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _popToRootVCBtn;
}

- (UIButton *)popToVCBtn {
    if ( _popToVCBtn ) return _popToVCBtn;
    _popToVCBtn = [UIButton new];
    [_popToVCBtn setTitle:@"PopToVC" forState:UIControlStateNormal];
    [_popToVCBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popToVCBtn addTarget:self action:@selector(clickedPopToVCBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _popToVCBtn;
}

- (UIButton *)disableBtn {
    if ( _disableBtn ) return _disableBtn;
    _disableBtn = [UIButton new];
    [_disableBtn setTitle:@"Disable Gesture" forState:UIControlStateNormal];
    [_disableBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_disableBtn addTarget:self action:@selector(clickedDisableBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _disableBtn;
}

- (UIButton *)albumBtn {
    if ( _albumBtn ) return _albumBtn;
    _albumBtn = [UIButton new];
    [_albumBtn setTitle:@"Album" forState:UIControlStateNormal];
    [_albumBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_albumBtn addTarget:self action:@selector(clickedAlbumBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _albumBtn;
}
- (UIScrollView *)backgroundScrollView {
    if ( _backgroundScrollView ) return _backgroundScrollView;
    _backgroundScrollView = [UIScrollView new];
    _backgroundScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _backgroundScrollView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
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
        
        UILabel *label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:30];
        label.text = [NSString stringWithFormat:@"%zd", i];
        label.frame = CGRectMake(20, 20, 0, 0);
        [label sizeToFit];
        [view addSubview:label];
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
    NSLog(@"%zd - %s", __LINE__, __func__);
}

- (UIView *)testOtherGestureView {
    if ( _testOtherGestureView ) return _testOtherGestureView;
    _testOtherGestureView = [UIView new];
    _testOtherGestureView.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                            green:1.0 * (arc4random() % 256 / 255.0)
                                                             blue:1.0 * (arc4random() % 256 / 255.0)
                                                            alpha:1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestTap:)];
    [_testOtherGestureView addGestureRecognizer:tap];
    return _testOtherGestureView;
}

- (void)handleTestTap:(UITapGestureRecognizer *)tap {
    NSLog(@"%zd - %s", __LINE__, __func__);
}

@end
