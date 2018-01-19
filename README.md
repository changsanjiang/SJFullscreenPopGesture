# SJFullscreenPopGesture
全屏返回手势. 适用于带有视频播放器的App.    
Fullscreen pop gesture. An application with a video player is available.    

### Use
```ruby
pod 'SJFullscreenPopGesture'
```

### Example
<img src="https://github.com/changsanjiang/SJVideoPlayerBackGR/blob/master/SJBackGRProject/SJBackGRProject/ex1.gif" />
### Features
- Fullscreen Pop Gesture. 
- Fade Area. 
- Disable Gesture.
### Disable 
```Objective-C
// If you want to disable the gestures, you can do the same as below.
#import "UIViewController+SJVideoPlayerAdd.h"
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sj_DisableGestures = YES;
}
```
### Fade Area
```Objective-C
// 如果想某个区域不触发手势, 可以这样做.
// If you want an area to not trigger gestures, you can do the same as below.
#import "UIViewController+SJVideoPlayerAdd.h"
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sj_fadeAreaViews = @[_btn, _view2];
    // or
    self.sj_fadeArea = @[@(_btn.frame), @(_view2.frame)];
}
```
### Common Method
```Objective-C
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
```

### 天朝
https://juejin.im/post/5a150c166fb9a04524057832
