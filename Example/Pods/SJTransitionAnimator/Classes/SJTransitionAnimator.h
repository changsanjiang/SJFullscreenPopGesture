//
//  SJTransitionAnimator.h
//  SJTransitionAnimator
//
//  Created by BlueDancer on 2017/7/6.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SJTransitionAnimator;

typedef void(^_Nullable AnimationBlockType)(SJTransitionAnimator *animator, id<UIViewControllerContextTransitioning> transitionContext);

@interface SJTransitionAnimator : NSObject

/*!
 *  animation default is 0.5;
 */
@property (nonatomic, assign, readwrite) NSTimeInterval duration;

@property (nonatomic, weak, readwrite) UIViewController *modalViewController;

+ (instancetype)sharedAnimator;

- (instancetype)initWithModalViewController:(__weak UIViewController *)viewController;

/*!
 *  注意  retain count
 *  如果没有设置将会使用默认的动画
 */
- (void)presentedAnimation:(AnimationBlockType)pBlock
        dismissedAnimation:(AnimationBlockType)dBlock;

- (void)presentedAnima:(void(^)(SJTransitionAnimator *anim, UIView *presentView, id<UIViewControllerContextTransitioning> transitionContext))pBlock
        dismissedAnima:(void(^)(SJTransitionAnimator *anim, UIView *presentView, id<UIViewControllerContextTransitioning> transitionContext))dBlock;

- (void)modalViewController:(__weak UIViewController *)viewController
         presentedAnimation:(AnimationBlockType)pBlock
         dismissedAnimation:(AnimationBlockType)dBlock;

/// 淡入淡出
- (void)fadeInAndFadeOut;

/// 推进推出
- (void)pushAndPop;

- (void)clearPresentedAnimationBlock;

- (void)clearDismissedAnimationBlock;

@end

NS_ASSUME_NONNULL_END
