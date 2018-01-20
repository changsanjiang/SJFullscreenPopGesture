//
//  UINavigationController+SJVideoPlayerAdd.h
//  SJBackGR
//
//  Created by BlueDancer on 2017/9/26.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Settings)

/*!
 *  bar Color
 *
 *  如果导航栏上出现了黑底, 请设置他.
 **/
@property (nonatomic, strong, readwrite, nullable) UIColor *sj_backgroundColor;

/*!
 *  default is 0.35.
 *
 *  0.0 .. 1.0
 *  偏移多少, 触发pop操作
 **/
@property (nonatomic) float scMaxOffset;

@end

NS_ASSUME_NONNULL_END
