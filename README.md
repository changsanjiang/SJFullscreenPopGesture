# SJFullscreenPopGesture
全屏返回手势. 适用于带有视频播放器的App.    
Fullscreen pop gesture. An application with a video player is available.    

### Use
```ruby
pod 'SJFullscreenPopGesture'
```
### 天朝

https://juejin.im/post/5a150c166fb9a04524057832

### Example
<img src="https://github.com/changsanjiang/SJVideoPlayerBackGR/blob/master/SJBackGRProject/SJBackGRProject/ex1.gif" />

### 功能
- 全屏手势(兼容scrollView, 当scrollView.contentOffset.x==0时, 触发全屏手势).
- 指定盲区, 在指定区域不触发全屏手势. 可指定Frame或者View.
- 禁用, 可在某个页面禁用手势.

如果好用, 兄弟, 给个 Star 吧.

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

