//
//  NextViewController.m
//  SJBackGR
//
//  Created by BlueDancer on 2017/9/26.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "NextViewController.h"
#import "NavigationController.h"
#import <SJUIFactory.h>
#import "NoNavViewController.h"
#import "TestPageViewController.h"
#import "SJFullscreenPopGesture_Example-Bridging-Header.h"

@interface NextViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *pushBtn;

@property (nonatomic, strong) UIButton *modalBtn;

@property (nonatomic, strong, readonly) UIButton *popToRootVCBtn;

@property (nonatomic, strong, readonly) UIButton *popToVCBtn;

@property (nonatomic, strong, readonly) UIButton *disableBtn;

@property (nonatomic, strong, readonly) UIButton *albumBtn;

@property (nonatomic, strong, readonly) UIButton *modalBtn_NoNav;

@property (nonatomic, strong, readonly) UIButton *pageVC;

@property (nonatomic, strong, readonly) UIButton *changeBackDisplayModeBtn;

@property (nonatomic, strong, readonly) UIScrollView *backgroundScrollView;

@property (nonatomic, strong, readonly) UIView *testPanBackgroundView;

@property (nonatomic, strong, readonly) UIView *testOtherGestureView;

@property (nonatomic, strong, readonly) UIImageView *testGIFImageView;

@end

@implementation NextViewController

@synthesize popToRootVCBtn = _popToRootVCBtn;
@synthesize popToVCBtn = _popToVCBtn;
@synthesize backgroundScrollView = _backgroundScrollView;
@synthesize testPanBackgroundView = _testPanBackgroundView;
@synthesize disableBtn = _disableBtn;
@synthesize albumBtn = _albumBtn;
@synthesize testOtherGestureView = _testOtherGestureView;
@synthesize modalBtn_NoNav = _modalBtn_NoNav;
@synthesize pageVC = _pageVC;
@synthesize changeBackDisplayModeBtn = _changeBackDisplayModeBtn;
@synthesize testGIFImageView = _testGIFImageView;

- (void)dealloc {
    NSLog(@"%s - %d", __func__, (int)__LINE__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ( self.sj_disableFullscreenGesture ) {
        [_disableBtn setTitle:@"Enable gesture" forState:UIControlStateNormal];
    }
    else {
        [_disableBtn setTitle:@"Disable gesture" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                green:1.0 * (arc4random() % 256 / 255.0)
                                                 blue:1.0 * (arc4random() % 256 / 255.0)
                                                alpha:1];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.sj_displayMode = SJPreViewDisplayModeOrigin;
    [self.view addSubview:self.backgroundScrollView];
    
    self.label = [UILabel new];
    _label.text = @"人生若只如初见，何事秋风悲画扇。";
    [_label sizeToFit];
    _label.center = CGPointMake(self.view.frame.size.width * 0.5, 100);
    [self.view addSubview:_label];
    
    self.testGIFImageView.frame = CGRectMake(8, _label.frame.origin.y + 80, 200, 50);
    [self.view addSubview:self.testGIFImageView];
    [self.view addSubview:self.changeBackDisplayModeBtn];
    _changeBackDisplayModeBtn.frame = CGRectMake(8, _testGIFImageView.frame.origin.y + 60, 200, 30);
    
    
    self.testPanBackgroundView.frame = CGRectMake(self.view.frame.size.width * 0.5, 130, 100, 100);
    [self.view addSubview:self.testPanBackgroundView];
    
    self.testOtherGestureView.frame = CGRectMake(self.view.frame.size.width * 0.5, 250, 100, 100);
    [self.view addSubview:self.testOtherGestureView];
    
    self.pushBtn = [UIButton new];
    [_pushBtn setTitle:@"Push" forState:UIControlStateNormal];
    [_pushBtn addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_pushBtn];
    _pushBtn.bounds = CGRectMake(0, 0, 300, 50);
    _pushBtn.center = self.view.center;
    [_pushBtn sizeToFit];
    
    
    #pragma mark -
    
    self.sj_viewWillBeginDragging = ^(UIViewController *vc) {
//        NSLog(@"begin");
    };
    
    self.sj_viewDidDrag = ^(UIViewController *vc) {
//        NSLog(@"dragging");
//        NSLog(@"scMaxOffset = %f", vc.navigationController.scMaxOffset);
    };
    
    self.sj_viewDidEndDragging = ^(UIViewController *vc) {
//        NSLog(@"end");
    };
    
    #pragma mark -
    
    self.modalBtn = [UIButton new];
    [_modalBtn setTitle:@"Modal_Nav" forState:UIControlStateNormal];
    [_modalBtn addTarget:self action:@selector(presentNextVC) forControlEvents:UIControlEventTouchUpInside];
    [_modalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_modalBtn];
    CGRect frame = _pushBtn.frame;
    frame.origin.y += 30;
    _modalBtn.frame = frame;
    [_modalBtn sizeToFit];
    
    [self.view addSubview:self.popToRootVCBtn];
    frame.origin.y += 30;
    _popToRootVCBtn.frame = frame;
    [_popToRootVCBtn sizeToFit];
    
    [self.view addSubview:self.popToVCBtn];
    frame.origin.y += 30;
    _popToVCBtn.frame = frame;
    [_popToVCBtn sizeToFit];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"modalClose" style:UIBarButtonItemStyleDone target:self action:@selector(clickedCloseItem)];
    
    [self.view addSubview:self.disableBtn];
    frame.origin.y += 30;
    _disableBtn.frame = frame;
    [_disableBtn sizeToFit];
    
    [self.view addSubview:self.albumBtn];
    frame.origin.y += 30;
    _albumBtn.frame = frame;
    [_albumBtn sizeToFit];
    
    [self.view addSubview:self.modalBtn_NoNav];
    frame.origin.y += 30;
    _modalBtn_NoNav.frame = frame;
    [_modalBtn_NoNav sizeToFit];
    
    [self.view addSubview:self.pageVC];
    frame.origin.y += 30;
    _pageVC.frame = frame;
    [_pageVC sizeToFit];
    
    
    
    #pragma mark - Fade Area
    
    UIView *testFadeAreaView = [UIView new];
    testFadeAreaView.frame = CGRectMake(200, 20, 100, 50);
    testFadeAreaView.backgroundColor = [UIColor orangeColor];
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = @"Test fade area";
    [tipsLabel sizeToFit];
    [testFadeAreaView addSubview:tipsLabel];
    [self.view addSubview:testFadeAreaView];

//    self.sj_fadeArea = @[@(_pushBtn.frame), @(testFadeAreaView.frame)];
    self.sj_blindAreaViews = @[testFadeAreaView];
    
}

- (IBAction)pushNextVC:(id)sender {
    NextViewController * vc = [NextViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentNextVC {
//    NoNavViewController *vc = [NoNavViewController new];
    NextViewController * vc = [NextViewController new];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickedCloseItem {
    NSLog(@"-------");
    NSLog(@"仅对 modal 有效");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Views

- (UIButton *)popToRootVCBtn {
    if ( _popToRootVCBtn ) return _popToRootVCBtn;
    _popToRootVCBtn = [UIButton new];
    [_popToRootVCBtn setTitle:@"PopToRootVC" forState:UIControlStateNormal];
    [_popToRootVCBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popToRootVCBtn addTarget:self action:@selector(clickedPopToRootVCBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _popToRootVCBtn;
}

- (void)clickedPopToRootVCBtn:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
- (UIButton *)popToVCBtn {
    if ( _popToVCBtn ) return _popToVCBtn;
    _popToVCBtn = [UIButton new];
    [_popToVCBtn setTitle:@"PopToVC" forState:UIControlStateNormal];
    [_popToVCBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popToVCBtn addTarget:self action:@selector(clickedPopToVCBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _popToVCBtn;
}

- (void)clickedPopToVCBtn:(UIButton *)btn {
    NSInteger random = arc4random() % self.navigationController.childViewControllers.count - 1;
    if ( random < 0 ) random = 0;
    [self.navigationController popToViewController:self.navigationController.childViewControllers[random] animated:YES];
}

#pragma mark -
- (UIButton *)disableBtn {
    if ( _disableBtn ) return _disableBtn;
    _disableBtn = [UIButton new];
    [_disableBtn setTitle:@"Disable Gesture" forState:UIControlStateNormal];
    [_disableBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_disableBtn addTarget:self action:@selector(clickedDisableBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _disableBtn;
}

- (void)clickedDisableBtn:(UIButton *)btn {
    self.sj_disableFullscreenGesture = !self.sj_disableFullscreenGesture;
    if ( self.sj_disableFullscreenGesture ) {
        [_disableBtn setTitle:@"Enable gesture" forState:UIControlStateNormal];
    }
    else {
        [_disableBtn setTitle:@"Disable gesture" forState:UIControlStateNormal];
    }
}

#pragma mark -
- (UIButton *)albumBtn {
    if ( _albumBtn ) return _albumBtn;
    _albumBtn = [UIButton new];
    [_albumBtn setTitle:@"Album" forState:UIControlStateNormal];
    [_albumBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_albumBtn addTarget:self action:@selector(clickedAlbumBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _albumBtn;
}

- (void)clickedAlbumBtn:(UIButton *)btn {
    [[SJUIImagePickerControllerFactory shared] alterPickerViewControllerWithController:self alertTitle:@"" msg:@"" photoLibrary:^(UIImage *selectedImage) {
        [btn setBackgroundImage:selectedImage forState:UIControlStateNormal];
    } camera:^(UIImage *selectedImage) {
        [btn setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }];
}

#pragma mark -
- (UIButton *)modalBtn_NoNav {
    if ( _modalBtn_NoNav ) return _modalBtn_NoNav;
    _modalBtn_NoNav = [UIButton new];
    [_modalBtn_NoNav setTitle:@"Modal_NoNav" forState:UIControlStateNormal];
    [_modalBtn_NoNav setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_modalBtn_NoNav addTarget:self action:@selector(clickedModal_NoNavBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _modalBtn_NoNav;
}

- (void)clickedModal_NoNavBtn:(UIButton *)btn {
    NoNavViewController * vc = [NoNavViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -
- (UIButton *)pageVC {
    if ( _pageVC ) return _pageVC;
    _pageVC = [UIButton new];
    [_pageVC setTitle:@"PageVC" forState:UIControlStateNormal];
    [_pageVC setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_pageVC addTarget:self action:@selector(clickedPageVC:) forControlEvents:UIControlEventTouchUpInside];
    return _pageVC;
}

- (void)clickedPageVC:(UIButton *)btn {
    TestPageViewController *vc = [TestPageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (UIButton *)changeBackDisplayModeBtn {
    if ( _changeBackDisplayModeBtn ) return _changeBackDisplayModeBtn;
    _changeBackDisplayModeBtn = [UIButton new];
    [_changeBackDisplayModeBtn setTitle:@"ChangeBackDisplayModeBtn" forState:UIControlStateNormal];
    [_changeBackDisplayModeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_changeBackDisplayModeBtn addTarget:self action:@selector(clickedChangeBackDisplayModeBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _changeBackDisplayModeBtn;
}

- (void)clickedChangeBackDisplayModeBtn:(UIButton *)btn {
    if ( self.sj_displayMode == SJPreViewDisplayModeSnapshot ) {
        self.sj_displayMode = SJPreViewDisplayModeOrigin;
        [_changeBackDisplayModeBtn setTitle:@"SJPreViewDisplayMode_Origin" forState:UIControlStateNormal];
    }
    else {
        self.sj_displayMode = SJPreViewDisplayModeSnapshot;
        [_changeBackDisplayModeBtn setTitle:@"SJPreViewDisplayMode_Snapshot" forState:UIControlStateNormal];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushNextVC:nil];
    });
}

#pragma mark -
- (UIScrollView *)backgroundScrollView {
    if ( _backgroundScrollView ) return _backgroundScrollView;
    _backgroundScrollView = [UIScrollView new];
    _backgroundScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _backgroundScrollView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    int subCount = 5;
    _backgroundScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * subCount, CGRectGetHeight(self.view.frame));
    for ( int i = 0 ; i < subCount ; i ++ ) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                               green:1.0 * (arc4random() % 256 / 255.0)
                                                blue:1.0 * (arc4random() % 256 / 255.0)
                                               alpha:1];
        view.frame = CGRectMake(CGRectGetWidth(self.view.frame) * i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [_backgroundScrollView addSubview:view];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:30];
        label.text = [NSString stringWithFormat:@"%d", i];
        label.frame = CGRectMake(20, 20, 0, 0);
        [label sizeToFit];
        [view addSubview:label];
    }
    
    _backgroundScrollView.pagingEnabled = YES;
    return _backgroundScrollView;
}

- (UIView *)testPanBackgroundView {
    if ( _testPanBackgroundView ) return _testPanBackgroundView;
    _testPanBackgroundView = [UIView new];
    _testPanBackgroundView.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                            green:1.0 * (arc4random() % 256 / 255.0)
                                                             blue:1.0 * (arc4random() % 256 / 255.0)
                                                            alpha:1];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestPan:)];
    [_testPanBackgroundView addGestureRecognizer:pan];
    return _testPanBackgroundView;
}

- (void)handleTestPan:(UIPanGestureRecognizer *)pan {
    NSLog(@"%d - %s", __LINE__, __func__);
}

- (UIView *)testOtherGestureView {
    if ( _testOtherGestureView ) return _testOtherGestureView;
    _testOtherGestureView = [UIView new];
    _testOtherGestureView.backgroundColor = [UIColor colorWithRed:1.0 * (arc4random() % 256 / 255.0)
                                                            green:1.0 * (arc4random() % 256 / 255.0)
                                                             blue:1.0 * (arc4random() % 256 / 255.0)
                                                            alpha:1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestTap:)];
    [_testOtherGestureView addGestureRecognizer:tap];
    return _testOtherGestureView;
}

- (void)handleTestTap:(UITapGestureRecognizer *)tap {
    NSLog(@"%d - %s", __LINE__, __func__);
}

- (UIImageView *)testGIFImageView {
    if ( _testGIFImageView ) return _testGIFImageView;
    _testGIFImageView = [SJUIImageViewFactory imageViewWithViewMode:UIViewContentModeScaleAspectFit];
    _testGIFImageView.image = getImage([NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"]], UIScreen.mainScreen.scale);
    return _testGIFImageView;
}
/**
 ref: YYKit
 UIImage(YYAdd)
 */
static UIImage *getImage(NSData *data, CGFloat scale) {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)(data), NULL);
    if (!source) return nil;
    
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        CFRelease(source);
        return [UIImage imageWithData:data scale:scale];
    }
    
    NSUInteger frames[count];
    double oneFrameTime = 1 / 50.0; // 50 fps
    NSTimeInterval totalTime = 0;
    NSUInteger totalFrame = 0;
    NSUInteger gcdFrame = 0;
    for (size_t i = 0; i < count; i++) {
        NSTimeInterval delay = _yy_CGImageSourceGetGIFFrameDelayAtIndex(source, i);
        totalTime += delay;
        NSInteger frame = lrint(delay / oneFrameTime);
        if (frame < 1) frame = 1;
        frames[i] = frame;
        totalFrame += frames[i];
        if (i == 0) gcdFrame = frames[i];
        else {
            NSUInteger frame = frames[i], tmp;
            if (frame < gcdFrame) {
                tmp = frame; frame = gcdFrame; gcdFrame = tmp;
            }
            while (true) {
                tmp = frame % gcdFrame;
                if (tmp == 0) break;
                frame = gcdFrame;
                gcdFrame = tmp;
            }
        }
    }
    NSMutableArray *array = [NSMutableArray new];
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!imageRef) {
            CFRelease(source);
            return nil;
        }
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        if (width == 0 || height == 0) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, bitmapInfo);
        CGColorSpaceRelease(space);
        if (!context) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef decoded = CGBitmapContextCreateImage(context);
        CFRelease(context);
        if (!decoded) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        UIImage *image = [UIImage imageWithCGImage:decoded scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGImageRelease(decoded);
        if (!image) {
            CFRelease(source);
            return nil;
        }
        for (size_t j = 0, max = frames[i] / gcdFrame; j < max; j++) {
            [array addObject:image];
        }
    }
    CFRelease(source);
    UIImage *image = [UIImage animatedImageWithImages:array duration:totalTime];
    return image;
}

/**
 ref: YYKit
 UIImage(YYAdd)
 */
static NSTimeInterval _yy_CGImageSourceGetGIFFrameDelayAtIndex(CGImageSourceRef source, size_t index) {
    NSTimeInterval delay = 0;
    CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (dic) {
        CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
        if (dicGIF) {
            NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(dic);
    }
    
    // http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
    if (delay < 0.02) delay = 0.1;
    return delay;
}

@end
