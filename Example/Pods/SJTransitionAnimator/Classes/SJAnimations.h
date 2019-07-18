//
//  SJAnimations.h
//  SJTransitionAnimator
//
//  Created by BlueDancer on 2017/12/19.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAnimations : NSObject

/*!
 *  mask is image or view or layer.
 **/
- (void)centerMask:(id)mask context:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
