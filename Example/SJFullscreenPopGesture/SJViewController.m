//
//  SJViewController.m
//  SJFullscreenPopGesture
//
//  Created by changsanjiang on 07/18/2019.
//  Copyright (c) 2019 changsanjiang. All rights reserved.
//

#import "SJViewController.h"
#import "NextViewController.h"
#import "NoNavViewController.h"
#import <SJTransitionAnimator.h>
#import "SJTest2ViewController.h"
#import "WebViewController.h"
#import "TestMapViewViewController.h"
#import "TableViewController.h"

#import "SJFullscreenPopGesture_Example-Bridging-Header.h"

@interface SJViewController ()

@property (nonatomic, strong) UIButton *pushBtn;

@property (nonatomic, strong) UIButton *testBtn;

@end

@implementation SJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.pushBtn = [UIButton new];
    [_pushBtn setTitle:@"Push" forState:UIControlStateNormal];
    [_pushBtn addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_pushBtn];
    _pushBtn.bounds = CGRectMake(0, 0, 100, 50);
    _pushBtn.center = self.view.center;
    
    
    
    self.testBtn = [UIButton new];
    [_testBtn setTitle:@"Test" forState:UIControlStateNormal];
    [_testBtn addTarget:self action:@selector(testClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_testBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_testBtn];
    _testBtn.bounds = CGRectMake(0, 0, 100, 50);
    CGRect frame = _pushBtn.frame;
    frame.origin.y += 100;
    _testBtn.frame = frame;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushNextVC:(id)sender {
    NextViewController * vc = [NextViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testClicked:(UIButton *)btn {
    NoNavViewController *vc = [NoNavViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)test2Clicked:(id)sender {
    SJTest2ViewController *vc = [SJTest2ViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [SJTransitionAnimator sharedAnimator].modalViewController = nav;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)webClicked:(id)sender {
    WebViewController *vc = [WebViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)testMap:(id)sender {
    [self.navigationController pushViewController:[TestMapViewViewController new] animated:YES];
}

- (IBAction)testTableView:(id)sender {
    [self.navigationController pushViewController:[TableViewController new] animated:YES];
}

@end
