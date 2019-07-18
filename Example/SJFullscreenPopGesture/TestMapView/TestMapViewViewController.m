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
#import "SJFullscreenPopGesture_Example-Bridging-Header.h"

@interface TestMapViewViewController ()
@property (nonatomic, strong) MKMapView *mapView;
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
    // Do any additional setup after loading the view.
}

@end
