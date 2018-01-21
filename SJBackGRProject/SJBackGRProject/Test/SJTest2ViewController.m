//
//  SJTest2ViewController.m
//  SJBackGRProject
//
//  Created by BlueDancer on 2017/12/30.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJTest2ViewController.h"
#import <SJUIFactory/SJUIFactory.h>
#import <SJTransitionAnimator.h>
#import "NextViewController.h"

@interface SJTest2ViewController ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) BOOL dismissed;

@end

@implementation SJTest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                green:arc4random() % 256 / 255.0
                                                 blue:arc4random() % 256 / 255.0
                                                alpha:1];
    
    _btn = [SJUIButtonFactory buttonWithTitle:@"Jump" titleColor:[UIColor orangeColor] font:[UIFont boldSystemFontOfSize:20] target:self sel:@selector(clickedBtn:)];
    [_btn sizeToFit];
    _btn.center = self.view.center;
    [self.view addSubview:_btn];
    
    
    _closeBtn = [SJUIButtonFactory buttonWithTitle:@"Close" titleColor:[UIColor orangeColor] font:[UIFont boldSystemFontOfSize:20] target:self sel:@selector(close)];
    [_closeBtn sizeToFit];
    _closeBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [self.view addSubview:_closeBtn];
    
    
    // Do any additional setup after loading the view.
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
    _dismissed = YES;
}

- (void)clickedBtn:(UIButton *)btn {
    [self.navigationController pushViewController:[NextViewController new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ( !_dismissed ) [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
