//
//  TestMapViewViewController.m
//  SJBackGRProject
//
//  Created by BlueDancer on 2018/7/20.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "TestMapViewViewController.h"
#import <MapKit/MapKit.h>
#import <Masonry.h>

#import "UINavigationController+SJVideoPlayerAdd.h"
#import "UIViewController+SJVideoPlayerAdd.h"

@interface TestMapViewViewController ()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation TestMapViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    
    _button = [[UIButton alloc] initWithFrame:CGRectZero];
    [_button setTitle:@"切换手势" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor blackColor];
    [_button addTarget:self action:@selector(switchGestureType:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    
    self.sj_fadeArea = @[[NSValue valueWithCGRect:(CGRect){CGPointMake(100, 0), self.view.frame.size}]];
    
    // Do any additional setup after loading the view.
}

- (void)switchGestureType:(UIButton *)btn {
    switch ( self.navigationController.sj_gestureType ) {
        case SJFullscreenPopGestureType_Full: {
            self.navigationController.sj_gestureType = SJFullscreenPopGestureType_EdgeLeft;
            [btn setTitle:@"SJFullscreenPopGestureType_EdgeLeft" forState:UIControlStateNormal];
        }
            break;
        case SJFullscreenPopGestureType_EdgeLeft: {
            self.navigationController.sj_gestureType = SJFullscreenPopGestureType_Full;
            [btn setTitle:@"SJFullscreenPopGestureType_Full" forState:UIControlStateNormal];
        }
            break;
    }
}

@end
