//
//  SJScreenshotView.m
//  SJBackGR
//
//  Created by BlueDancer on 2017/9/27.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJScreenshotView.h"

@interface SJScreenshotView ()

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) UIImageView *screenshotImageView;

@end

@implementation SJScreenshotView

@synthesize containerView = _containerView;
@synthesize screenshotImageView = _screenshotImageView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    [self _SJScreenshotViewSetupUI];
    return self;
}

- (void)_SJScreenshotViewSetupUI {
    [self addSubview:self.containerView];
    [_containerView addSubview:self.screenshotImageView];

    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerView]|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_containerView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_containerView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_containerView)]];
    
    _screenshotImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_screenshotImageView]|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_screenshotImageView)]];
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_screenshotImageView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_screenshotImageView)]];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _screenshotImageView.image = image;
}

- (UIView *)containerView {
    if ( _containerView ) return _containerView;
    _containerView = [UIView new];
    return _containerView;
}

- (UIImageView *)screenshotImageView {
    if ( _screenshotImageView ) return _screenshotImageView;
    _screenshotImageView = [UIImageView new];
    return _screenshotImageView;
}

@end
