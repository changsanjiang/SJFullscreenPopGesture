//
//  UIViewController+SJVideoPlayerAdd.h
//  SJBackGR
//
//  Created by BlueDancer on 2017/9/27.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SJVideoPlayerAdd)

/*!
 *  The specified area does not trigger gestures.
 *  In the array is subview frame.
 *  @[@(self.label.frame)]
 *
 *  指定区域不触发手势. see `sj_fadeAreaViews` method
 **/
@property (nonatomic, strong) NSArray<NSValue *> *sj_fadeArea;

/*!
 *  The specified area does not trigger gestures.
 *  In the array is subview.
 *  @[@(self.label)]
 *
 *  指定区域不触发手势.
 **/
@property (nonatomic, strong) NSArray<UIView *> *sj_fadeAreaViews;

/*!
 *  disable pop Gestures. default is NO.
 *
 *  禁用全屏手势. 默认是 NO.
 **/
@property (nonatomic, assign, readwrite) BOOL sj_DisableGestures;


@property (nonatomic, copy, readwrite) void(^sj_viewWillBeginDragging)(__kindof UIViewController *vc);
@property (nonatomic, copy, readwrite) void(^sj_viewDidDrag)(__kindof UIViewController *vc);
@property (nonatomic, copy, readwrite) void(^sj_viewDidEndDragging)(__kindof UIViewController *vc);

@end
