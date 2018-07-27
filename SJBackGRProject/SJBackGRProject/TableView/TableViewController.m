//
//  TableViewController.m
//  SJBackGRProject
//
//  Created by BlueDancer on 2018/7/27.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "TableViewController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const UITableViewCellID = @"UITableViewCell";

@interface TableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, readonly) UITableView *tableView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    _tableView.frame = self.view.bounds;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Do any additional setup after loading the view.
}

@synthesize tableView = _tableView;
- (UITableView *)tableView {
    if ( _tableView ) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [_tableView registerClass:NSClassFromString(UITableViewCellID) forCellReuseIdentifier:UITableViewCellID];
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID forIndexPath:indexPath];
    cell.contentView.backgroundColor =  [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                        green:arc4random() % 256 / 255.0
                                                         blue:arc4random() % 256 / 255.0
                                                        alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0) {
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}
@end
NS_ASSUME_NONNULL_END
