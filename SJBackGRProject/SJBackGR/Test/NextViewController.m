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

@end

@implementation NextViewController

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
 
    
    self.sj_viewWillBeginDragging = ^(UIViewController *vc) {
        NSLog(@"begin");
    };
    
    self.sj_viewDidDrag = ^(UIViewController *vc) {
        NSLog(@"dragging");
        NSLog(@"scMaxOffset = %f", vc.navigationController.scMaxOffset);
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"modal_close" style:UIBarButtonItemStyleDone target:self action:@selector(clickedCloseItem)];
    
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

@end
