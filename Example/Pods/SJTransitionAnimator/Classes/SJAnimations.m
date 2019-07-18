//
//  SJAnimations.m
//  SJTransitionAnimator
//
//  Created by BlueDancer on 2017/12/19.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJAnimations.h"

@interface SJAnimations ()<CAAnimationDelegate>

@property (nonatomic, strong, readonly) NSMutableArray<id<UIViewControllerContextTransitioning>> *contextsM;

@end

@implementation SJAnimations

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contextsM = [NSMutableArray array];
    }
    return self;
}

- (void)centerMask:(id)mask context:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *presentView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:presentView];
    
    CALayer *maskLayer = nil;
    if ( [mask isKindOfClass:[UIImage class]] ) {
        maskLayer = [CALayer layer];
        maskLayer.contents = (id)[(UIImage *)mask CGImage];
        maskLayer.bounds = (CGRect){CGPointZero, [(UIImage *)mask size]};
        maskLayer.position = [[UIApplication sharedApplication] keyWindow].center;
    }
    else if ( [mask isKindOfClass:[CALayer class]] ) {
        maskLayer = (CALayer *)mask;
    }
    else if ( [mask isKindOfClass:[UIView class]] ) {
        maskLayer = [(UIView *)mask layer];
    }

    presentView.layer.mask = maskLayer;
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    anima.duration = 1;
    anima.beginTime = CACurrentMediaTime() + 0.25; // 延迟1秒
    anima.delegate = self;
    
    NSValue *initalBounds = [NSValue valueWithCGRect:maskLayer.bounds];
    CGFloat width = maskLayer.bounds.size.width;
    CGFloat height = maskLayer.bounds.size.height;
    NSValue *secondBounds = [NSValue valueWithCGRect:(CGRect){CGPointZero, CGSizeMake( width * 0.85, height * 0.85)}];
    NSValue *finalBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, 2000, 2000)];
    anima.values = @[initalBounds, secondBounds, finalBounds];
    anima.keyTimes = @[@0, @0.5, @1];
    
    anima.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    
    [presentView.layer.mask addAnimation:anima forKey:@"maskAnimation"];
    
    [UIView animateWithDuration:0.25 delay:1.3 options:UIViewAnimationOptionTransitionNone animations:^{
        presentView.transform = CGAffineTransformMakeScale(0.98, 0.98);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            presentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
    [self.contextsM addObject:transitionContext];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_contextsM enumerateObjectsUsingBlock:^(id<UIViewControllerContextTransitioning>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj completeTransition:YES];
    }];
    
    [_contextsM removeAllObjects];
}

@end
