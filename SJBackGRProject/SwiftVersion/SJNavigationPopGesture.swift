//
//  SJNavigationPopGesture.swift
//  SwiftVersion
//
//  Created by 畅三江 on 2018/2/24.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

import UIKit
import WebKit


/// getsture type, default is .edgeLeft
enum SJNavigationPopGestureType {
    
    case edgeLeft
    
    case full
}


/// pop转场模式
///
/// - shifting: 做偏移
/// - shadeAndShifting: 阴影遮盖并且偏移
enum SJTransitionMode {
    case shifting
    case shadeAndShifting
}


fileprivate var cls_screenshotView: _SJScreenshotView?


public extension UINavigationController {
    
    /**
     *  bar Color. If there is a black top on the navigation bar, set it.
     *
     *  如果导航栏上出现了黑底, 请设置他.
     **/
    public var sj_backgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &kSJBackgroundColor) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &kSJBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     *  default is 0.35. The proportion of pop gesture offset.
     *  It is useful only when the gesture type is set to `SJFullscreenPopGestureType_Full`.
     *
     *  0.0 .. 1.0
     *  偏移多少, 触发pop.
     **/
    public var sj_maxOffset: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &kSJMaxOffset) as? CGFloat
        }
        
        set {
            objc_setAssociatedObject(self, &kSJMaxOffset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
//    
//    fileprivate class var SJ_screenshotView: _SJScreenshotView {
//        get {
//            if ( nil != cls_screenshotView ) {
//                return cls_screenshotView!
//            }
//            else {
//                cls_screenshotView = _SJScreenshotView()
//                let bounds = UIScreen.main.bounds
//                let width = min(bounds.width, bounds.height)
//                let height = max(bounds.width, bounds.height)
//                cls_screenshotView!.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
//                return cls_screenshotView!
//            }
//        }
//    }
//    
//    fileprivate var SJ_screenshotView: _SJScreenshotView {
//        get {
//            
//        }
//    }
}


public extension UIViewController {
    
    /**
     *  Consider `webview`.
     *  when this property is set, will be enabled system gesture to back last web page, until it can't go back.
     *
     *  考虑`webview`. 当设置此属性后, 将会`启用手势返回上一个网页`.
     **/
    public weak var sj_considerWebView: WKWebView? {
        get {
            return objc_getAssociatedObject(self, &kSJConsiderWebView) as? WKWebView
        }
        
        set {
            objc_setAssociatedObject(self, &kSJConsiderWebView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /**
     *  The specified area does not trigger gestures. It does not affect other ViewControllers.
     *  In the array is subview frame.
     *  @[@(self.label.frame)]
     *  It is useful only when the gesture type is set to `SJFullscreenPopGestureType_Full`.
     *
     *  指定区域不触发手势. see `sj_fadeAreaViews` method
     *  只有设置 手势类型为 `SJFullscreenPopGestureType_Full` 的时候有用.
     **/
    public var sj_fadeArea: [NSValue]? {
        get {
            return objc_getAssociatedObject(self, &kSJFadeArea) as? [NSValue]
        }
        
        set {
            objc_setAssociatedObject(self, &kSJFadeArea, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     *  The specified area does not trigger gestures. It does not affect other ViewControllers.
     *  In the array is subview.
     *  @[@(self.label)]
     *  It is useful only when the gesture type is set to `SJFullscreenPopGestureType_Full`.
     *
     *  指定区域不触发手势.
     *  只有设置 手势类型为 `SJFullscreenPopGestureType_Full` 的时候有用.
     **/
    public var sj_fadeAreaViews: [UIView]? {
        get {
            return objc_getAssociatedObject(self, &kSJFadeAreaViews) as? [UIView]
        }
        
        set {
            objc_setAssociatedObject(self, &kSJFadeAreaViews, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     *  disable pop Gestures. default is NO. It does not affect other ViewControllers.
     *
     *  禁用全屏手势. 默认是 NO.
     **/
    public var sj_disableGestures: Bool? {
        get {
            return objc_getAssociatedObject(self, &kSJDisableGestures) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &kSJDisableGestures, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var sj_viewWillBeginDragging: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &kSJViewWillBeginDragging) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &kSJViewWillBeginDragging, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    public var sj_viewDidDrag: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &kSJViewDidDrag) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &kSJViewDidDrag, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    public var sj_viewDidEndDragging: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &kSJViewDidEndDragging) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &kSJViewDidEndDragging, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}

private extension UIViewController {
    
}

fileprivate class _SJScreenshotView : UIView {
    
    override init(frame: CGRect) {
        self.transitionMode = .shifting
        super.init(frame: frame)
        _setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupViews()  -> Void {
        self.addSubview(containerView)
        containerView.addSubview(shadeView)
        let bounds = UIScreen.main.bounds
        let width = min(bounds.width, bounds.height)
        let height = max(bounds.width, bounds.height)
        containerView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        shadeView.frame = containerView.frame
    }
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var shift: CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    private lazy var shadeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        return view
    }()
    
    private var beforeSnapshot: UIView?
    
    public var transitionMode: SJTransitionMode
    
    public func beginTrnsition(snapshot: UIView?) -> Void {
        self.containerView.transform = CGAffineTransform.init(translationX: shift, y: 0)
        switch transitionMode {
        case .shifting:
            shadeView.alpha = 0.001
            
        case .shadeAndShifting:
            let width = self.frame.width
            shadeView.transform = CGAffineTransform.init(translationX: -(shift + width), y: 0)
            shadeView.alpha = 1
        }
        
        let before = containerView.subviews.first
        if ( nil != snapshot && snapshot != before ) {
            if ( before != snapshot ) {
                before?.removeFromSuperview()
            }
            containerView.insertSubview(snapshot!, at: 0)
        }
        
        beforeSnapshot = snapshot
    }
    
    public func transitiongWithOffset(offset: CGFloat) -> Void {
        let width = self.frame.width
        if ( 0 == width ) {
            return
        }
        
        let rate = offset / width
        containerView.transform = CGAffineTransform.init(translationX: self.shift * ( 1 - rate ), y: 0)
        switch transitionMode {
        case .shifting:
                break
            
        case .shadeAndShifting:
            shadeView.alpha = 1 - rate
            shadeView.transform = CGAffineTransform.init(translationX: -(shift + width) + (shift * rate) + offset, y: 0)
        }
    }
    
    public func reset() -> Void {
        containerView.transform = CGAffineTransform.init(translationX: shift, y: 0)
        
        let width = self.frame.width
        switch transitionMode {
        case .shifting:
            break
            
        case .shadeAndShifting:
            shadeView.transform = CGAffineTransform.init(translationX: -(self.shift + width), y: 0)
            shadeView.alpha = 1
        }
    }
    
    public func finishedTransition() -> Void {
        containerView.transform = CGAffineTransform.identity
        shadeView.transform = CGAffineTransform.identity
        shadeView.alpha = 0.001
    }
}

private var kSJBackgroundColor: String?
private var kSJMaxOffset: String?

private var kSJConsiderWebView: String?
private var kSJFadeArea: String?
private var kSJFadeAreaViews: String?
private var kSJDisableGestures: String?
private var kSJViewWillBeginDragging: String?
private var kSJViewDidDrag: String?
private var kSJViewDidEndDragging: String?
