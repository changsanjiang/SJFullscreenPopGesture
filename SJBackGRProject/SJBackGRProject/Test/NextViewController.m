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

@interface NextViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *pushBtn;

@property (nonatomic, strong) UIButton *modalBtn;

@property (nonatomic, strong, readonly) UIButton *nativeModeBtn;

@property (nonatomic, strong, readonly) UIButton *customModeBtn;

@end

@implementation NextViewController {
    UISegmentedControl *_segmented;
}


@synthesize nativeModeBtn = _nativeModeBtn;
@synthesize customModeBtn = _customModeBtn;

- (void)dealloc {
    NSLog(@"%s - %zd", __func__, __LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                green:1.0 * (arc4random() % 256 / 255.0)
                                                 blue:1.0 * (arc4random() % 256 / 255.0)
                                                alpha:1];
    
    self.label = [UILabel new];
    _label.text = @"人生若只如初见，何事秋风悲画扇。";
    [_label sizeToFit];
    _label.center = CGPointMake(self.view.frame.size.width * 0.5, 100);
    [self.view addSubview:_label];
    
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
    _modalBtn.bounds = CGRectMake(0, 0, 100, 50);
    CGRect frame = _pushBtn.frame;
    frame.origin.y += 100;
    _modalBtn.frame = frame;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"modalClose" style:UIBarButtonItemStyleDone target:self action:@selector(clickedCloseItem)];
    
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
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickedCloseItem {
    NSLog(@"-------");
    NSLog(@"仅对 modal 有效");
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
