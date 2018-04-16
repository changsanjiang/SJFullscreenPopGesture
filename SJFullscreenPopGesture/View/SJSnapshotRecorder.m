//
//  SJSnapshotServer.m
//  SJBackGRProject
//
//  Created by BlueDancer on 2018/4/16.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "SJSnapshotRecorder.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

static const char *kSJSnapshot = "kSJSnapshot";

@interface SJSnapshotRecorder : NSObject
@property (nonatomic, strong, readonly) UIView *rootView;
@property (nonatomic, strong, readonly) UIView *bar_snapshotView;
@property (nonatomic, strong, readonly) UIView *preViewContainerView;
@property (nonatomic, strong, readonly) UIView *shadeView;
- (instancetype)initWithNavigationController:(__weak UINavigationController *__nullable)nav index:(NSInteger)index;
- (instancetype)init;

- (void)preparePopViewController;
- (void)endPopViewController;
@end

@interface SJSnapshotRecorder () {
    __weak UINavigationController *_nav;
    NSInteger _index;
}
@end

@implementation SJSnapshotRecorder
- (instancetype)init {
    return [self initWithNavigationController:nil index:0];
}
- (instancetype)initWithNavigationController:(__weak UINavigationController *__nullable)nav index:(NSInteger)index {
    self = [super init];
    if ( !self ) return nil;
    _rootView = [UIView new];
    _rootView.frame = [UIScreen mainScreen].bounds;
    
    _preViewContainerView = [UIView new];
    _preViewContainerView.frame = _rootView.bounds;
    [_rootView addSubview:_preViewContainerView];
    
    // bar
    if ( nav ) {
        if ( !nav.navigationBarHidden ) {
             _bar_snapshotView = [nav.view resizableSnapshotViewFromRect:CGRectMake(0, 0, nav.navigationBar.frame.size.width, nav.navigationBar.frame.size.height - nav.navigationBar.subviews.firstObject.frame.origin.y + [UIScreen mainScreen].scale) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            [_rootView addSubview:_bar_snapshotView];
        }
    }
    
    _shadeView = [UIView new];
    _shadeView.frame = _rootView.bounds;
    _shadeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [_rootView addSubview:_shadeView];
    
    _nav = nav;
    _index = index;
    
    return self;
}

- (void)preparePopViewController {
    if ( _nav ) {
        UIView *preView = _nav.childViewControllers[_index].view;
        [_preViewContainerView insertSubview:preView atIndex:0];
    }
}

- (void)endPopViewController {
    [_preViewContainerView.subviews.firstObject removeFromSuperview];
}

@end

@interface SJSnapshotServer ()
@property (nonatomic, readonly) CGFloat shift;
@end

@implementation SJSnapshotServer

+ (instancetype)shared {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _shift = -[UIScreen mainScreen].bounds.size.width * 0.382;
    return self;
}

#pragma mark - action
- (void)nav:(UINavigationController *)nav pushViewController:(UIViewController *)viewController {
    SJSnapshotRecorder *recorder = [[SJSnapshotRecorder alloc] initWithNavigationController:nav index:nav.childViewControllers.count - 1];
    objc_setAssociatedObject(viewController, kSJSnapshot, recorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -
- (void)nav:(UINavigationController *)nav preparePopViewController:(UIViewController *)viewController {
    SJSnapshotRecorder *recorder = objc_getAssociatedObject(viewController, kSJSnapshot);
    [recorder preparePopViewController];
    
    // add recorder view
    [nav.view.superview insertSubview:recorder.rootView atIndex:0];
    
    recorder.rootView.transform = CGAffineTransformMakeTranslation( self.shift, 0);

    switch ( _transitionMode ) {
        case SJScreenshotTransitionModeShifting: {
            recorder.shadeView.alpha = 0.001;
        } break;
        case SJScreenshotTransitionModeShadeAndShifting: {
            recorder.shadeView.alpha = 1;
            CGFloat width = recorder.rootView.frame.size.width;
            recorder.shadeView.transform = CGAffineTransformMakeTranslation(- (self.shift + width), 0);
        } break;
    }
}

- (void)nav:(UINavigationController *)nav poppingViewController:(UIViewController *)viewController offset:(double)offset {
    SJSnapshotRecorder *recorder = objc_getAssociatedObject(viewController, kSJSnapshot);
    CGFloat width = recorder.rootView.frame.size.width;
    if ( 0 == width ) return;
    switch ( _transitionMode ) {
        case SJScreenshotTransitionModeShifting: {
            CGFloat rate = offset / width;
            recorder.rootView.transform = CGAffineTransformMakeTranslation( self.shift * ( 1 - rate ), 0 );
        } break;
        case SJScreenshotTransitionModeShadeAndShifting: {
            CGFloat rate = offset / width;
            recorder.rootView.transform = CGAffineTransformMakeTranslation( self.shift * ( 1 - rate ), 0 );
            recorder.shadeView.alpha = 1 - rate;
            recorder.shadeView.transform = CGAffineTransformMakeTranslation( - (self.shift + width) + (self.shift * rate) + offset, 0 );
        } break;
    }
}

- (void)nav:(UINavigationController *)nav willEndPopViewController:(UIViewController *)viewController pop:(BOOL)pop {
    SJSnapshotRecorder *recorder = objc_getAssociatedObject(viewController, kSJSnapshot);
    if ( pop ) {
        recorder.rootView.transform = CGAffineTransformIdentity;
        recorder.shadeView.transform = CGAffineTransformIdentity;
        recorder.shadeView.alpha = 0.001;
    }
    else {
        switch ( _transitionMode ) {
            case SJScreenshotTransitionModeShifting: {} break;
            case SJScreenshotTransitionModeShadeAndShifting: {
                recorder.shadeView.alpha = 1;
                CGFloat width = recorder.rootView.frame.size.width;
                recorder.shadeView.transform = CGAffineTransformMakeTranslation(- (self.shift + width), 0);
            } break;
        }
    }
}

- (void)nav:(UINavigationController *)nav endPopViewController:(UIViewController *)viewController {
    SJSnapshotRecorder *recorder = objc_getAssociatedObject(viewController, kSJSnapshot);
    [recorder endPopViewController];
    [recorder.rootView removeFromSuperview];
}
@end
NS_ASSUME_NONNULL_END
