//
//  SJTransitionAnimator.m
//  SJTransitionAnimator
//
//  Created by BlueDancer on 2017/7/6.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJTransitionAnimator.h"


typedef NS_ENUM(NSUInteger, ModalViewControllerState) {
    ModalViewControllerStatePresented = 0,
    ModalViewControllerStateDismissed = 1
};


@interface SJTransitionAnimator (TransitioningDelegateMethods)<UIViewControllerTransitioningDelegate>@end

@interface SJTransitionAnimator (UIViewControllerAnimatedTransitioningMethods)<UIViewControllerAnimatedTransitioning>@end


@interface SJTransitionAnimator ()

@property (nonatomic, assign) ModalViewControllerState      state;
@property (nonatomic, copy)   AnimationBlockType            presentedAnimationBlock;
@property (nonatomic, copy)   AnimationBlockType            dismissedAnimationBlock;

@end


// MARK: TransitioningDelegateMethods


@implementation SJTransitionAnimator (TransitioningDelegateMethods)

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.state = ModalViewControllerStatePresented;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.state = ModalViewControllerStateDismissed;
    return self;
}


@end


// MARK: UIViewControllerAnimatedTransitioningMethods


@implementation SJTransitionAnimator (UIViewControllerAnimatedTransitioningMethods)


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    switch (self.state) {
        case ModalViewControllerStatePresented: {
            self.presentedAnimationBlock(self, transitionContext);
        }
            break;
        case ModalViewControllerStateDismissed: {
            self.dismissedAnimationBlock(self, transitionContext);
        }
            break;
        default:
            NSLog(@"default error, %s, %zd", __FILE__, __LINE__);
            break;
    }
}

@end



@implementation SJTransitionAnimator

// MARK: Init

+ (instancetype)sharedAnimator {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)initWithModalViewController:(UIViewController *)viewController {
    self = [self init];
    self.modalViewController = viewController;
    return self;
}

- (instancetype)init {
    self = [super init];
    if ( self ) {
        // default is 0.5;
        _duration = 0.5;
    }
    return self;
}

// MARK: Setter

- (void)setModalViewController:(UIViewController *)modalViewController {
    _modalViewController = modalViewController;
    modalViewController.transitioningDelegate  = self;
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
}

- (void)presentedAnimation:(AnimationBlockType _Nullable)pBlock
        dismissedAnimation:(AnimationBlockType _Nullable)dBlock {
    _presentedAnimationBlock = pBlock;
    _dismissedAnimationBlock = dBlock;
}

// MARK: Lazy

- (AnimationBlockType)presentedAnimationBlock {
    if ( _presentedAnimationBlock ) return _presentedAnimationBlock;
    return ^(SJTransitionAnimator * _Nonnull animator, id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
        [animator defaultPresentedAnimation:transitionContext];
    };
}

- (AnimationBlockType)dismissedAnimationBlock {
    if ( _dismissedAnimationBlock ) return _dismissedAnimationBlock;
    return ^(SJTransitionAnimator * _Nonnull animator, id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
        [animator defaultDismissedAnimation:transitionContext];
    };
}

// MARK: 缺省动画

- (void)defaultPresentedAnimation:(id<UIViewControllerContextTransitioning>  _Nonnull)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *presentView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:presentView];
    presentView.alpha = 0.001;
    presentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [UIView animateWithDuration:self.duration animations:^{
        presentView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)defaultDismissedAnimation:(id<UIViewControllerContextTransitioning>  _Nonnull)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [UIView animateWithDuration:self.duration animations:^{
        fromView.alpha = 0.001;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        // clear
        [self clearPresentedAnimationBlock];
        [self clearDismissedAnimationBlock];
    }];
}

#pragma mark -

- (void)clearPresentedAnimationBlock {
    _presentedAnimationBlock = nil;
}

- (void)clearDismissedAnimationBlock {
    _dismissedAnimationBlock = nil;
}

@end
