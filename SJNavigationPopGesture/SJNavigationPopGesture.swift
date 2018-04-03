//
//  SJNavigationPopGesture.swift
//  SwiftVersion
//
//  Created by 畅三江 on 2018/2/24.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

import UIKit
import WebKit

public class SJNavigationPopGesture {

    private static var installed: Bool?
    
    public class func install() -> Void {
        if ( nil != installed ) {
            return
        }
        
        installed = true

        var cls = UIViewController.self
        var selArr = [
            [
                #selector(UIViewController.present(_:animated:completion:)),
                #selector(UIViewController.sj_present(_:animated:completion:))
            ],
            [
                #selector(UIViewController.dismiss(animated:completion:)),
                #selector(UIViewController.sj_dismiss(animated:completion:))
            ]
        ]
        _exchangeImp(cls, selArr)
        
        
        cls = UINavigationController.self
        selArr = [
            [
                #selector(UINavigationController.pushViewController(_:animated:)),
                #selector(UINavigationController.sj_pushViewController(_:animated:))
            ],
            [
                #selector(UINavigationController.popViewController(animated:)),
                #selector(UINavigationController.sj_popViewController(animated:))
            ],
            [
                #selector(UINavigationController.popToViewController(_:animated:)),
                #selector(UINavigationController.sj_popToViewController(_:animated:))
            ],
            [
                #selector(UINavigationController.popToRootViewController(animated:)),
                #selector(UINavigationController.sj_popToRootViewController(animated:))
            ],
        ]
        _exchangeImp(cls, selArr)
    }
    
    private class func _exchangeImp(_ cls: AnyClass, _ selArr: [[Selector]]) -> Void {
        for sel in selArr {
            let originalSelector = sel[0]
            let swizzledSelector = sel[1]
            let originalMethod = class_getInstanceMethod(cls, originalSelector);
            let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}


/// getsture type, default is .edgeLeft.  手势类型, 默认是边缘触发
public enum SJNavigationPopGestureType {
    
    case edgeLeft
    
    case full
}


/// pop 转场方式
///
/// - shifting: 做偏移
/// - shadeAndShifting: 阴影遮盖并且偏移
public enum SJTransitionMode {
    case shifting
    case shadeAndShifting
}


public extension UINavigationController {
    
    /// 手势类型, default is `edgeLeft`
    public var sj_gestureType: SJNavigationPopGestureType {
        get {
            return self.SJ_selectedType
        }
        
        set {
            self.SJ_selectedType = newValue
        }
    }
    
    /// pop 转场方式, default is `shifting`
    public var sj_transitionMode: SJTransitionMode {
        get {
            return static_screenshotView.transitionMode
        }
        
        set {
            static_screenshotView.transitionMode = newValue
        }
    }
    
    /// pop gesture state.
    public var sj_popGestureState: UIGestureRecognizerState {
        get {
            var gesture: UIGestureRecognizer?
            switch SJ_selectedType {
            case .edgeLeft:
                gesture = self.SJ_edgePan
            case .full:
                gesture = self.SJ_pan
            }
            return gesture!.state
        }
    }
    
    /// bar Color. If there is a black top on the navigation bar, set it. 如果导航栏上出现了黑底, 可以设置他.
    public var sj_backgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJBackgroundColor) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.navigationBar.barTintColor = sj_backgroundColor
            self.navigationBar.backgroundColor = sj_backgroundColor
        }
    }
    
    /**
     *  default is 0.35. The proportion of pop gesture offset.
     *  It is useful only when the gesture type is set to `SJFullscreenPopGestureType_Full`.
     *
     *  0.0 .. 1.0
     *  偏移多少, 触发pop.
     **/
    public var sj_maxOffset: CGFloat {
        get {
            let offset = objc_getAssociatedObject(self, &SJAssociatedKeys.kSJMaxOffset) as? CGFloat
            if ( nil == offset ) {
                return 0.35
            }
            return offset!
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJMaxOffset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
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
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJConsiderWebView) as? WKWebView
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJConsiderWebView, newValue, .OBJC_ASSOCIATION_ASSIGN)
            newValue?.allowsBackForwardNavigationGestures = true
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
    public var sj_fadeArea: [CGRect]? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJFadeArea) as? [CGRect]
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJFadeArea, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJFadeAreaViews) as? [UIView]
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJFadeAreaViews, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     *  disable pop Gestures. default is NO. It does not affect other ViewControllers.
     *
     *  禁用全屏手势. 默认是 NO.
     **/
    public var sj_disableGestures: Bool? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJDisableGestures) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJDisableGestures, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var sj_viewWillBeginDragging: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJViewWillBeginDragging) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJViewWillBeginDragging, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    public var sj_viewDidDrag: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJViewDidDrag) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJViewDidDrag, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    public var sj_viewDidEndDragging: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJViewDidEndDragging) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJViewDidEndDragging, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}


private extension UIViewController {
    @objc func sj_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        
        if ( viewControllerToPresent.isKind(of: UIAlertController.self) == false ) {
            SJ_updateScreenshot()
        }
        
        self.sj_present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    @objc func sj_dismiss(animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        
        if ( self.isKind(of: UIAlertController.self) == false && self.presentedViewController?.isKind(of: UIAlertController.self) == false ) {
            
            if ( self.isKind(of: UINavigationController.self) == true &&
                 self.presentingViewController != nil ) {
                SJ_dumpingScreenshot(self.childViewControllers.count)
            }
            else if ( self.navigationController != nil &&
                self.presentingViewController != nil ) {
                SJ_dumpingScreenshot((self.navigationController?.childViewControllers.count)! + 1)
            }
            else {
                SJ_dumpingScreenshot(1)
            }
        }
        
        self.sj_dismiss(animated: flag, completion: completion)
    }
}

private extension UINavigationController {
    
    var SJ_tookOver: Bool! {
        get {
            let tookOver = objc_getAssociatedObject(self, &SJAssociatedKeys.kSJTookOver) as? Bool
            if ( tookOver != nil ) {
                return tookOver
            }
            return false
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJTookOver, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func sj_navSettings() -> Void {
        self.SJ_tookOver = true
        self.interactivePopGestureRecognizer?.isEnabled = false
        let type = self.SJ_selectedType
        self.SJ_selectedType = type // need update
        
        // border shadow
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.view.layer.shadowOffset = CGSize.init(width: 0.5, height: 0);
        self.view.layer.shadowColor = UIColor.init(white: 0.2, alpha: 1).cgColor
        self.view.layer.shadowOpacity = 1;
        self.view.layer.shadowRadius = 2;
        self.view.layer.shadowPath = UIBezierPath.init(rect: self.view.bounds).cgPath
        CATransaction.commit()
    }
    
    @objc func sj_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if ( self.interactivePopGestureRecognizer != nil &&
             self.SJ_tookOver == false  ) {
            self.sj_navSettings()
        }
        SJ_updateScreenshot()
        self.sj_pushViewController(viewController, animated: animated) // note: If Crash, please confirm that `viewController 'is ` UIViewController'(`UINavigationController` cannot be pushed).
    }
    
    @objc func sj_popViewController(animated: Bool) -> UIViewController? {
        SJ_dumpingScreenshot(1)
        return self.sj_popViewController(animated: animated)
    }
    
    @objc func sj_popToRootViewController(animated: Bool) -> [UIViewController]? {
        SJ_dumpingScreenshot(self.childViewControllers.count - 1)
        return self.sj_popToRootViewController(animated: animated)
    }
    
    @objc func sj_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        
        for i in 0...(self.childViewControllers.count - 1) {
            let subVC = self.childViewControllers[i]
            if ( subVC == viewController ) {
                SJ_dumpingScreenshot(self.childViewControllers.count - 1 - i)
                break
            }
        }
        return self.sj_popToViewController(viewController, animated: animated)
    }
}

private var static_screenshotView: _SJScreenshotView = {
    let view = _SJScreenshotView()
    let bounds = UIScreen.main.bounds
    let width = min(bounds.width, bounds.height)
    let height = max(bounds.width, bounds.height)
    view.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
    return view
}()

private var static_snapshotsM: [UIView] = [UIView]()

private var static_window: UIWindow = {
    let delegate = UIApplication.shared.delegate as AnyObject
    return delegate.value(forKey: "window") as! UIWindow
}()

private func SJ_updateScreenshot() -> Void {
    let view = static_window.snapshotView(afterScreenUpdates: false)
    if ( nil != view ) {
        static_snapshotsM.append(view!)
    }
}

private func SJ_dumpingScreenshot(_ num: Int) -> Void {
    if ( num <= 0 || num >= static_snapshotsM.count ) {
        return
    }
    
    static_snapshotsM.removeSubrange(Range.init(NSRange.init(location: static_snapshotsM.count - num, length: num))!)
}


// MARK: - Handle Pop Gesture
extension UINavigationController : UIGestureRecognizerDelegate {
    
    private var SJ_selectedType: SJNavigationPopGestureType {
        get {
            let type = objc_getAssociatedObject(self, &SJAssociatedKeys.kSJSelectedType) as? SJNavigationPopGestureType
            if ( nil == type ) {
                return SJNavigationPopGestureType.edgeLeft
            }
            return type!
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJSelectedType, newValue, .OBJC_ASSOCIATION_RETAIN)
            
            switch newValue {
            case .edgeLeft:
                self.view.addGestureRecognizer(self.SJ_edgePan)
                self.view.removeGestureRecognizer(self.SJ_pan)
                
            case .full:
                self.view.addGestureRecognizer(self.SJ_pan)
                self.view.removeGestureRecognizer(self.SJ_edgePan)
            }
        }
    }
    
    private var SJ_pan: UIPanGestureRecognizer {
        get {
            var pan = objc_getAssociatedObject(self, &SJAssociatedKeys.kSJPan) as? UIPanGestureRecognizer
            if ( pan == nil ) {
                pan = UIPanGestureRecognizer.init(target: self, action: #selector(SJ_handlePanGR(_:)))
                pan?.delegate = self
                pan?.delaysTouchesBegan = true
                objc_setAssociatedObject(self, &SJAssociatedKeys.kSJPan, pan, .OBJC_ASSOCIATION_RETAIN)
            }
            return pan!
        }
    }
    
    private var SJ_edgePan: UIScreenEdgePanGestureRecognizer {
        get {
            var pan = objc_getAssociatedObject(self, &SJAssociatedKeys.kSJPan) as? UIScreenEdgePanGestureRecognizer
            if ( pan == nil ) {
                pan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(SJ_handlePanGR(_:)))
                pan?.delegate = self
                pan?.delaysTouchesBegan = true
                pan?.edges = UIRectEdge.left
                objc_setAssociatedObject(self, &SJAssociatedKeys.kSJEdgePan, pan, .OBJC_ASSOCIATION_RETAIN)
            }
            return pan!
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isTransitioning = self.value(forKey: "_isTransitioning") as! Bool
        if ( self.topViewController?.sj_disableGestures == true ||
             isTransitioning == true ||
             self.topViewController?.sj_considerWebView?.canGoBack == true ) {
            return false
        }
        else if ( self.childViewControllers.count <= 1 ) {
            return false
        }
        else {
            return true
        }
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        if ( self.SJ_selectedType == .edgeLeft ) {
            return true
        }
        
        if ( SJ_isFadeArea(gestureRecognizer.location(in: self.view)) ) {
            return false
        }
        
        let translate = gestureRecognizer.translation(in: self.view)
        if ( translate.x > 0 && 0 == translate.y ) {
            return true
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if ( gestureRecognizer.state == UIGestureRecognizerState.failed ||
             gestureRecognizer.state == UIGestureRecognizerState.cancelled ) {
            return false
        }   
        else if ( otherGestureRecognizer.isMember(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) == true ||
                  otherGestureRecognizer.isMember(of: NSClassFromString("UIScrollViewPagingSwipeGestureRecognizer")!) == true
               && otherGestureRecognizer.isKind(of: UIScrollView.self) == true ) {
            let scrollView = otherGestureRecognizer.view as! UIScrollView
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            return SJ_considerScrollView(scrollView, panGesture, otherGestureRecognizer)
        }
        else if ( otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) ) {
            return false
        }
        
        return true
    }
    
    private func SJ_isFadeArea(_ point: CGPoint) -> Bool {
        var isFadeArea = false
        let topView = self.topViewController?.view
        var rect = CGRect.init()
        
        if ( 0 != self.topViewController?.sj_fadeArea?.count ) {
            for r in (self.topViewController!.sj_fadeArea)! {
                if ( self.isNavigationBarHidden == false ) {
                    rect = self.view.convert(r, from: topView)
                }
                if ( rect.contains(point) == true ) {
                    isFadeArea = true
                    break
                }
            }
        }
        
        if ( isFadeArea != true &&
             0 != self.topViewController?.sj_fadeAreaViews?.count ) {
            for subView in self.topViewController!.sj_fadeAreaViews! {
                let r = subView.frame
                if ( self.isNavigationBarHidden == false ) {
                    rect = self.view.convert(r, from: topView)
                }
                if ( rect.contains(point) == true ) {
                    isFadeArea = true
                    break
                }
            }
        }
        
        return isFadeArea
    }
    
    private func SJ_considerScrollView(_ scrollView: UIScrollView, _ gestureRecognizer: UIPanGestureRecognizer, _ otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if ( scrollView.isKind(of: NSClassFromString("_UIQueuingScrollView")!) == true ) {
            return SJ_considerQueuingScrollView(scrollView, gestureRecognizer, otherGestureRecognizer)
        }
        
        let translate = gestureRecognizer.translation(in: gestureRecognizer.view)
        if ( 0 == scrollView.contentOffset.x + scrollView.contentInset.left && !scrollView.isDecelerating && translate.x > 0 && translate.y == 0 ) {
            SJ_cancellGesture(otherGestureRecognizer)
            return true
        }
        
        return false
    }
    
    private func SJ_considerQueuingScrollView(_ scrollView: UIScrollView, _ gestureRecognizer: UIGestureRecognizer, _ otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let pageVC = SJ_findingPageViewController(scrollView)
        let dataSource = pageVC?.dataSource
        var beforeViewController: UIViewController?
        if ( dataSource != nil && 0 != pageVC?.viewControllers?.count ) {
            beforeViewController = dataSource?.pageViewController(pageVC!, viewControllerBefore: (pageVC?.viewControllers?.first)!)
        }
        
        if ( beforeViewController != nil || scrollView.isDecelerating ) {
            return false
        }
        
        SJ_cancellGesture(otherGestureRecognizer)
        return true
    }
    
    private func SJ_findingPageViewController(_ scrollView: UIScrollView) -> UIPageViewController? {
        var responder = scrollView.next
        while responder?.isKind(of: UIPageViewController.self) == false {
            responder = responder?.next
            if ( responder?.isMember(of: UIResponder.self) == true ||
                 nil == responder ) {
                responder = nil;
                break;
            }
        }
        return responder as? UIPageViewController
    }
    
    private func SJ_cancellGesture(_ gesture: UIGestureRecognizer) -> Void {
        gesture.setValue(UIGestureRecognizerState.cancelled, forKey: "state")
    }
    
    @objc private func SJ_handlePanGR(_ pan:UIPanGestureRecognizer) -> Void {
        let offset = pan.translation(in: self.view).x
        switch pan.state {
        case .possible: break
        case .began:
            SJ_ViewWillBeginDragging(offset)
        case .changed:
            SJ_ViewDidDrag(offset)
        case .ended, .cancelled, .failed:
            SJ_ViewDidEndDragging(offset)
        }
    }
    
    private func SJ_ViewWillBeginDragging(_ offset: CGFloat) -> Void {
        self.view.endEditing(true)
        self.view.superview?.insertSubview(static_screenshotView, at: 0)
        
        static_screenshotView.isHidden = false
        static_screenshotView.beginTrnsition(snapshot: static_snapshotsM.last)
        if ( self.topViewController?.sj_viewWillBeginDragging != nil ) {
            self.topViewController?.sj_viewWillBeginDragging!(self.topViewController!)
        }
        self.SJ_ViewDidDrag(offset)
    }
    
    private func SJ_ViewDidDrag(_ off: CGFloat) -> Void {
        var offset = off

        if ( offset < 0 ) {
            offset = 0
        }
        
        self.view.transform = CGAffineTransform.init(translationX: offset, y: 0)
        static_screenshotView.transitiongWithOffset(offset: offset)
        if ( self.topViewController?.sj_viewDidDrag != nil ) {
            self.topViewController?.sj_viewDidDrag!(self.topViewController!)
        }
    }
    
    private func SJ_ViewDidEndDragging(_ offset: CGFloat) -> Void {
        let maxWidth = self.view.frame.width
        if ( 0 == maxWidth ) {
            return
        }
        
        let rate = offset / maxWidth
        let maxOffset = self.sj_maxOffset
        let pop: Bool = (rate > maxOffset) == true
        var duration = CGFloat(0.25)
        if ( pop == false ) {
            duration = duration * ( offset / (maxOffset * maxWidth) )  + 0.05
        }
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            if ( pop ) {
                self.view.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
                static_screenshotView.finishedTransition()
            }
            else {
                self.view.transform = CGAffineTransform.identity
                static_screenshotView.reset()
            }
        }) { (finished) in
            if ( pop ) {
                self.popViewController(animated: false)
                self.view.transform = CGAffineTransform.identity
            }
            
            static_screenshotView.isHidden = true
            if ( self.topViewController?.sj_viewDidEndDragging != nil ) {
                self.topViewController?.sj_viewDidEndDragging!(self.topViewController!)
            }
        }
    }
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
        return -floor(UIScreen.main.bounds.width * 0.382)
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

/// Note the use of static var in a private nested struct—this pattern creates the static associated object key we need but doesn’t muck up the global namespace. ref: http://nshipster.com/swift-objc-runtime/
fileprivate struct SJAssociatedKeys {
    
    static var kSJTookOver: String?
    
    static var kSJSelectedType: String?
    static var kSJPan: String?
    static var kSJEdgePan: String?
    
    static var kSJBackgroundColor: String?
    static var kSJMaxOffset: String?
    
    static var kSJConsiderWebView: String?
    static var kSJFadeArea: String?
    static var kSJFadeAreaViews: String?
    static var kSJDisableGestures: String?
    static var kSJViewWillBeginDragging: String?
    static var kSJViewDidDrag: String?
    static var kSJViewDidEndDragging: String?
}
