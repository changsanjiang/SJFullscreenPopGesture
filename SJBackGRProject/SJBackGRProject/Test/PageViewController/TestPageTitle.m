//
//  TestPageTitle.m
//  SJBackGRProject
//
//  Created by BlueDancer on 2018/2/3.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "TestPageTitle.h"

@implementation TestPageTitle

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if ( !self ) return nil;
    _title = title;
    return self;
}
@end
