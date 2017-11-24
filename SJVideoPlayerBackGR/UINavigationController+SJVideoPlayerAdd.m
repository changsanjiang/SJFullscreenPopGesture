//
//  UINavigationController+SJVideoPlayerAdd.m
//  SJBackGR
//
//  Created by BlueDancer on 2017/9/26.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "UINavigationController+SJVideoPlayerAdd.h"
#import <objc/message.h>
#import "UIViewController+SJVideoPlayerAdd.h"
#import "SJScreenshotView.h"


#define SJ_Shift        (-[UIScreen mainScreen].bounds.size.width * 0.382)



#pragma mark -

static SJScreenshotView *SJVideoPlayer_screenshotView;
static NSMutableArray<UIImage *> * SJVideoPlayer_screenshotImagesM;



#pragma mark - UIViewController

@interface UIViewController (SJVideoPlayerExtension)

@property (nonatomic, strong, readonly) SJScreenshotView *SJVideoPlayer_screenshotView;
@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> * SJVideoPlayer_screenshotImagesM;

@end

@implementation UIViewController (SJVideoPlayerExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class vc = [self class];
        
        // dismiss
        Method dismissViewControllerAnimatedCompletion = class_getInstanceMethod(vc, @selector(dismissViewControllerAnimated:completion:));
        Method SJVideoPlayer_dismissViewControllerAnimatedCompletion = class_getInstanceMethod(vc, @selector(SJVideoPlayer_dismissViewControllerAnimated:completion:));
        
        method_exchangeImplementations(SJVideoPlayer_dismissViewControllerAnimatedCompletion, dismissViewControllerAnimatedCompletion);
    });
}

- (void)SJVideoPlayer_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if ( self.navigationController && self.presentingViewController ) {
        // reset image
        [self SJVideoPlayer_dumpingScreenshotWithNum:(NSInteger)self.navigationController.childViewControllers.count - 1]; // 由于最顶层的视图还未截取, 所以这里 - 1. 以下相同.
        [self SJVideoPlayer_resetScreenshotImage];
    }
    
    // call origin method
    [self SJVideoPlayer_dismissViewControllerAnimated:flag completion:completion];
}

- (void)SJVideoPlayer_resetScreenshotImage {
    [[self class] SJVideoPlayer_resetScreenshotImage];
}

- (void)SJVideoPlayer_updateScreenshot {
    // get scrrenshort
    id appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = [appDelegate valueForKey:@"window"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(window.frame.size.width, window.frame.size.height), YES, 0);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // add to container
    [self.SJVideoPlayer_screenshotImagesM addObject:viewImage];
    
    // change screenshotImage
    [self.SJVideoPlayer_screenshotView setImage:viewImage];
}

- (void)SJVideoPlayer_dumpingScreenshotWithNum:(NSInteger)num {
    if ( num <= 0 || num > self.SJVideoPlayer_screenshotImagesM.count ) return;
    [self.SJVideoPlayer_screenshotImagesM removeObjectsInRange:NSMakeRange(self.SJVideoPlayer_screenshotImagesM.count - num, num)];
}

- (SJScreenshotView *)SJVideoPlayer_screenshotView {
    return [[self class] SJVideoPlayer_screenshotView];
}

- (NSMutableArray<UIImage *> *)SJVideoPlayer_screenshotImagesM {
    return [[self class] SJVideoPlayer_screenshotImagesM];
}

+ (SJScreenshotView *)SJVideoPlayer_screenshotView {
    if ( SJVideoPlayer_screenshotView ) return SJVideoPlayer_screenshotView;
    SJVideoPlayer_screenshotView = [SJScreenshotView new];
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGFloat width = MIN(bounds.size.width, bounds.size.height);
    CGFloat height = MAX(bounds.size.width, bounds.size.height);
    SJVideoPlayer_screenshotView.frame = CGRectMake(0, 0, width, height);
    SJVideoPlayer_screenshotView.hidden = YES;
    return SJVideoPlayer_screenshotView;
}

+ (NSMutableArray<UIImage *> *)SJVideoPlayer_screenshotImagesM {
    if ( SJVideoPlayer_screenshotImagesM ) return SJVideoPlayer_screenshotImagesM;
    SJVideoPlayer_screenshotImagesM = [NSMutableArray array];
    return SJVideoPlayer_screenshotImagesM;
}

+ (void)SJVideoPlayer_resetScreenshotImage {
    // remove last screenshot
    [self.SJVideoPlayer_screenshotImagesM removeLastObject];
    // update screenshotImage
    [self.SJVideoPlayer_screenshotView setImage:[self.SJVideoPlayer_screenshotImagesM lastObject]];
}

@end



#pragma mark - UINavigationController
@interface UINavigationController (SJVideoPlayerExtension)<UINavigationControllerDelegate>

@property (nonatomic, assign, readwrite) BOOL isObserver;

@end

@implementation UINavigationController (SJVideoPlayerExtension)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // App launching
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SJVideoPlayer_addscreenshotImageViewToWindow) name:UIApplicationDidFinishLaunchingNotification object:nil];
        
        Class nav = [self class];
        
        // Push
        Method pushViewControllerAnimated = class_getInstanceMethod(nav, @selector(pushViewController:animated:));
        Method SJVideoPlayer_pushViewControllerAnimated = class_getInstanceMethod(nav, @selector(SJVideoPlayer_pushViewController:animated:));
        method_exchangeImplementations(SJVideoPlayer_pushViewControllerAnimated, pushViewControllerAnimated);
        
        // Pop
        Method popViewControllerAnimated = class_getInstanceMethod(nav, @selector(popViewControllerAnimated:));
        Method SJVideoPlayer_popViewControllerAnimated = class_getInstanceMethod(nav, @selector(SJVideoPlayer_popViewControllerAnimated:));
        method_exchangeImplementations(popViewControllerAnimated, SJVideoPlayer_popViewControllerAnimated);
        
        // Pop Root VC
        Method popToRootViewControllerAnimated = class_getInstanceMethod(nav, @selector(popToRootViewControllerAnimated:));
        Method SJVideoPlayer_popToRootViewControllerAnimated = class_getInstanceMethod(nav, @selector(SJVideoPlayer_popToRootViewControllerAnimated:));
        method_exchangeImplementations(popToRootViewControllerAnimated, SJVideoPlayer_popToRootViewControllerAnimated);
        
        // Pop To View Controller
        Method popToViewControllerAnimated = class_getInstanceMethod(nav, @selector(popToViewController:animated:));
        Method SJVideoPlayer_popToViewControllerAnimated = class_getInstanceMethod(nav, @selector(SJVideoPlayer_popToViewController:animated:));
        method_exchangeImplementations(popToViewControllerAnimated, SJVideoPlayer_popToViewControllerAnimated);
    });
}

- (void)dealloc {
    if ( self.isObserver ) [self.interactivePopGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

- (void)setIsObserver:(BOOL)isObserver {
    objc_setAssociatedObject(self, @selector(isObserver), @(isObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

// App launching
+ (void)SJVideoPlayer_addscreenshotImageViewToWindow {
    UIWindow *window = [(id)[UIApplication sharedApplication].delegate valueForKey:@"window"];
    NSAssert(window, @"Window was not found and cannot continue!");
    [window insertSubview:self.SJVideoPlayer_screenshotView atIndex:0];
}

- (void)SJVideoPlayer_navSettings {
    self.isObserver = YES;
    
    [self.interactivePopGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    // use custom gesture
    self.useNativeGesture = NO;
    
    // border shadow
    self.view.layer.shadowOffset = CGSizeMake(-1, 0);
    self.view.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    self.view.layer.shadowRadius = 1;
    self.view.layer.shadowOpacity = 1;
    
    // delegate
    self.delegate = (id)[UINavigationController class];
}

// observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIScreenEdgePanGestureRecognizer *)gesture change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    switch ( gesture.state ) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            break;
        default: {
            // update
            self.useNativeGesture = self.useNativeGesture;
        }
            break;
    }
}

// Push
static UINavigationControllerOperation _navOperation;
- (void)SJVideoPlayer_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _navOperation = UINavigationControllerOperationPush;
    
    if ( self.interactivePopGestureRecognizer &&
        !self.isObserver ) [self SJVideoPlayer_navSettings];
    
    // push update screenshot
    [self SJVideoPlayer_updateScreenshot];
    // call origin method
    [self SJVideoPlayer_pushViewController:viewController animated:animated];
}

// Pop
- (UIViewController *)SJVideoPlayer_popViewControllerAnimated:(BOOL)animated {
    _navOperation = UINavigationControllerOperationPop;
    // call origin method
    return [self SJVideoPlayer_popViewControllerAnimated:animated];
}

// Pop To RootView Controller
- (NSArray<UIViewController *> *)SJVideoPlayer_popToRootViewControllerAnimated:(BOOL)animated {
    _navOperation = UINavigationControllerOperationPop;
    [self SJVideoPlayer_dumpingScreenshotWithNum:(NSInteger)self.childViewControllers.count - 1];
    return [self SJVideoPlayer_popToRootViewControllerAnimated:animated];
}

// Pop To View Controller
- (NSArray<UIViewController *> *)SJVideoPlayer_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _navOperation = UINavigationControllerOperationPop;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( viewController != obj ) return;
        *stop = YES;
        [self SJVideoPlayer_dumpingScreenshotWithNum:((NSInteger)self.childViewControllers.count - 1) - ((NSInteger)idx + 1)];
    }];
    return [self SJVideoPlayer_popToViewController:viewController animated:animated];
}

// navController delegate
static __weak UIViewController *_tmpShowViewController;
+ (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( _navOperation == UINavigationControllerOperationPush ) { return;}
    _tmpShowViewController = viewController;
}

+ (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( _navOperation != UINavigationControllerOperationPop ) return;
    if ( _tmpShowViewController != viewController ) return;
    
    // reset
    [self SJVideoPlayer_resetScreenshotImage];
    _tmpShowViewController = nil;
    _navOperation = UINavigationControllerOperationNone;
}

@end






#pragma mark - Gesture
@implementation UINavigationController (SJVideoPlayerAdd)

- (UIPanGestureRecognizer *)sj_pan {
    UIPanGestureRecognizer *sj_pan = objc_getAssociatedObject(self, _cmd);
    if ( sj_pan ) return sj_pan;
    sj_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SJVideoPlayer_handlePanGR:)];
    [self.view addGestureRecognizer:sj_pan];
    sj_pan.delegate = self;
    objc_setAssociatedObject(self, _cmd, sj_pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return sj_pan;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ( self.childViewControllers.count <= 1 ) return NO;
    CGPoint translate = [gestureRecognizer translationInView:self.view];
    BOOL possible = translate.x > 0 && translate.y == 0;
    if ( possible ) return YES;
    else return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ( [otherGestureRecognizer isMemberOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) {
        return NO;
    }
    
    if ([otherGestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] ||
        [otherGestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) {
        if ( [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] ) {
            return [self SJVideoPlayer_considerScrollView:(UIScrollView *)otherGestureRecognizer.view otherGestureRecognizer:otherGestureRecognizer];
        }
    }
    return YES;
}

- (BOOL)SJVideoPlayer_considerScrollView:(UIScrollView *)subScrollView otherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ( 0 != subScrollView.contentOffset.x ) return NO;
    
    CGPoint translate = [self.sj_pan translationInView:self.view];
    if ( translate.x <= 0 ) return NO;
    else {
        [otherGestureRecognizer setValue:@(UIGestureRecognizerStateCancelled) forKey:@"state"];
        return YES;
    }
}

- (void)SJVideoPlayer_handlePanGR:(UIPanGestureRecognizer *)pan {
    CGFloat offset = [pan translationInView:self.view].x;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            [self SJVideoPlayer_ViewWillBeginDragging];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if ( offset < 0 ) return;
            [self SJVideoPlayer_ViewDidDrag:offset];
        }
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self SJVideoPlayer_ViewDidEndDragging:offset];
        }
            break;
    }
}

- (UIScrollView *)SJVideoPlayer_findingSubScrollView {
    __block UIScrollView *scrollView = nil;
    [self.topViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( ![obj isKindOfClass:[UIScrollView class]] ) return;
        *stop = YES;
        scrollView = obj;
    }];
    
    return scrollView;
}

- (void)SJVideoPlayer_ViewWillBeginDragging {
    [self.view endEditing:YES]; // 让键盘消失
    
    self.SJVideoPlayer_screenshotView.hidden = NO;
    
    [self SJVideoPlayer_findingSubScrollView].scrollEnabled = NO;
    
    // call block
    if ( self.topViewController.sj_viewWillBeginDragging ) self.topViewController.sj_viewWillBeginDragging(self.topViewController);
    
    // begin animation
    self.SJVideoPlayer_screenshotView.transform = CGAffineTransformMakeTranslation(SJ_Shift, 0);
}

- (void)SJVideoPlayer_ViewDidDrag:(CGFloat)offset {
    self.view.transform = CGAffineTransformMakeTranslation(offset, 0);
    
    // call block
    if ( self.topViewController.sj_viewDidDrag ) self.topViewController.sj_viewDidDrag(self.topViewController);
    
    // continuous animation
    CGFloat rate = offset / self.view.frame.size.width;
    self.SJVideoPlayer_screenshotView.transform = CGAffineTransformMakeTranslation(SJ_Shift - SJ_Shift * rate, 0);
    [self.SJVideoPlayer_screenshotView setShadeAlpha:1 - rate];
}

- (void)SJVideoPlayer_ViewDidEndDragging:(CGFloat)offset {
    
    [self SJVideoPlayer_findingSubScrollView].scrollEnabled = YES;
    
    CGFloat rate = offset / self.view.frame.size.width;
    if ( rate < self.scMaxOffset ) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformIdentity;
            
            // reset status
            self.SJVideoPlayer_screenshotView.transform = CGAffineTransformMakeTranslation(SJ_Shift, 0);
            [self.SJVideoPlayer_screenshotView setShadeAlpha:1];
        } completion:^(BOOL finished) {
            self.SJVideoPlayer_screenshotView.hidden = YES;
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
            
            // finished animation
            self.SJVideoPlayer_screenshotView.transform = CGAffineTransformMakeTranslation(0, 0);
            [self.SJVideoPlayer_screenshotView setShadeAlpha:0.001];
        } completion:^(BOOL finished) {
            [self popViewControllerAnimated:NO];
            self.view.transform = CGAffineTransformIdentity;
            self.SJVideoPlayer_screenshotView.hidden = YES;
        }];
    }
    
    // call block
    if ( self.topViewController.sj_viewDidEndDragging ) self.topViewController.sj_viewDidEndDragging(self.topViewController);
}

@end







#pragma mark - Settings

@implementation UINavigationController (Settings)

- (void)setSj_backgroundColor:(UIColor *)sj_backgroundColor {
    objc_setAssociatedObject(self, @selector(sj_backgroundColor), sj_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.navigationBar.barTintColor = sj_backgroundColor;
    self.view.backgroundColor = sj_backgroundColor;
}

- (UIColor *)sj_backgroundColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setScMaxOffset:(float)scMaxOffset {
    objc_setAssociatedObject(self, @selector(scMaxOffset), @(scMaxOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)scMaxOffset {
    float offset = [objc_getAssociatedObject(self, _cmd) floatValue];
    if ( 0 == offset ) return 0.35;
    return offset;
}

- (void)setUseNativeGesture:(BOOL)useNativeGesture {
    objc_setAssociatedObject(self, @selector(useNativeGesture), @(useNativeGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    switch (self.interactivePopGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:  break;
        default: {
            self.interactivePopGestureRecognizer.enabled = useNativeGesture;
            self.sj_pan.enabled = !useNativeGesture;
        }
            break;
    }
}

- (BOOL)useNativeGesture {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end


