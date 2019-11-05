//
//  SJNavigationPopGesture.swift
//  SwiftVersion
//
//  Created by 畅三江 on 2018/2/24.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

import UIKit
import WebKit

@objc
public class SJFullscreenPopGesture: NSObject {
    
    @objc public static var gestureType: SJFullscreenPopGestureType = .edgeLeft
    
    @objc public static var transitionMode: SJFullscreenPopGestureTransitionMode = .shifting
    
    @objc public static var maxOffsetToTriggerPop: CGFloat = 0.35
    
    @objc public enum SJFullscreenPopGestureType: Int {
        
        case edgeLeft
        
        case full
    }
    
    @objc public enum SJFullscreenPopGestureTransitionMode: Int {
        
        case shifting
        
        case maskAndShifting
    }

    @objc public class func install() -> Void {
        if ( installed == true ) {
            return;
        }
        
        installed = true
        
        let cls = UINavigationController.self
        let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))
        let swizzledSelector = #selector(UINavigationController.sj_pushViewController(_:animated:))
        let originalMethod = class_getInstanceMethod(cls, originalSelector)!;
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)!;
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    private static var installed: Bool = false
    
}

@objc
public extension UIViewController {
    
    var sj_displayMode: SJPreViewDisplayMode {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJDisplayMode) as? SJPreViewDisplayMode ?? .snapshot;
        }
        
        set {
            edgesForExtendedLayout = UIRectEdge.init()
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJDisplayMode, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var sj_disableFullscreenGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.ksj_disableFullscreenGesture) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.ksj_disableFullscreenGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var sj_blindArea: [CGRect]? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.ksj_blindArea) as? [CGRect]
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.ksj_blindArea, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var sj_blindAreaViews: [UIView]? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.ksj_blindAreaViews) as? [UIView]
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.ksj_blindAreaViews, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var sj_viewWillBeginDragging: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.ksj_viewWillBeginDragging) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.ksj_viewWillBeginDragging, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var sj_viewDidDrag: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.ksj_viewDidDrag) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.ksj_viewDidDrag, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var sj_viewDidEndDragging: ((UIViewController) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.ksj_viewDidEndDragging) as? ((UIViewController) -> Void)
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.ksj_viewDidEndDragging, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var sj_considerWebView: WKWebView? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.ksj_considerWebView) as? WKWebView
        }
        
        set {
            newValue?.allowsBackForwardNavigationGestures = true
            objc_setAssociatedObject(self, &SJAssociatedKeys.ksj_considerWebView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    /// 返回时, 前视图的显示模式
    ///
    /// - snapshot: use screenshot view
    /// - origin: use origin view. If you use it, I will change `edgesForExtendedLayout` to `none` of viewController. 采用原始图, 如果使用它, 我会改变控制器的 edgesForExtendedLayout 为 none.
    @objc enum SJPreViewDisplayMode: Int {
        
        case snapshot
        
        case origin
    }
    
}

fileprivate extension UIViewController {
    var sj_previousViewControllerSnapshot: SJSnapshot? {
        get {
            return objc_getAssociatedObject(self, &SJAssociatedKeys.kSJSnapshot) as? SJSnapshot
        }
        
        set {
            objc_setAssociatedObject(self, &SJAssociatedKeys.kSJSnapshot, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

@objc
public extension UINavigationController {
    var sj_fullscreenGestureState: UIGestureRecognizer.State {
        get {
            return self.sj_fullscreenGesture.state
        }
    }
}

fileprivate extension UINavigationController {

    @objc func sj_pushViewController(_ viewController: UIViewController, animated: Bool) {
        sj_setupIfNeeded()
        SJTransitionHandler.shared.push(self, viewController)
        sj_pushViewController(viewController, animated: animated)
    }
    
    private func sj_setupIfNeeded() {
        if ( self.interactivePopGestureRecognizer == nil ) {
            return
        }
        
        let tookOver: Bool = objc_getAssociatedObject(self, &SJAssociatedKeys.kSJTookOver) != nil;
        
        if ( tookOver == true ) {
            
            return
        }
        
        objc_setAssociatedObject(self, &SJAssociatedKeys.kSJTookOver, true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.view.clipsToBounds = false
        
        // shadow
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        view.layer.shadowOffset = CGSize.init(width: 0.5, height: 0)
        view.layer.shadowColor = UIColor.init(white: 0.2, alpha: 1).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowPath = UIBezierPath.init(rect: view.bounds).cgPath
        CATransaction.commit()
        
        // gesture
        view.addGestureRecognizer(sj_fullscreenGesture)
    }
    
    var sj_fullscreenGesture: UIPanGestureRecognizer {
        get {
            if let gesture = objc_getAssociatedObject(self, &SJAssociatedKeys.k_FullscreenGesture) as? UIPanGestureRecognizer {
                return gesture
            }
            
            let gesture: UIPanGestureRecognizer = SJFullscreenPopGesture.gestureType == .edgeLeft ? UIScreenEdgePanGestureRecognizer.init() : UIPanGestureRecognizer.init()
            gesture.delaysTouchesBegan = true
            gesture.delegate = SJFullscreenPopGestureDelegate.shared
            gesture.addTarget(self, action: #selector(sj_handleFullscreenGesture(_:)))
            if SJFullscreenPopGesture.gestureType == .edgeLeft {
                (gesture as! UIScreenEdgePanGestureRecognizer).edges = .left
            }
            objc_setAssociatedObject(self, &SJAssociatedKeys.k_FullscreenGesture, gesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return gesture
        }
    }
    
    @objc private func sj_handleFullscreenGesture(_ pan: UIPanGestureRecognizer) {
        guard let viewController = topViewController else {
            return
        }
        
        let offset = pan.translation(in: self.view).x
        
        switch pan.state {
        case .began:
            SJTransitionHandler.shared.began(self, viewController, offset)
        case .changed:
            SJTransitionHandler.shared.changed(self, viewController, offset)
        case .ended, .cancelled, .failed:
            SJTransitionHandler.shared.completed(self, viewController, offset)
        case .possible: break
        @unknown default: break
        }
    }
}




fileprivate class SJFullscreenPopGestureDelegate: NSObject, UIGestureRecognizerDelegate {
 
    static let shared: SJFullscreenPopGestureDelegate = SJFullscreenPopGestureDelegate.init()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let nav = _lookupResponder(gestureRecognizer.view!, UINavigationController.self), nav.children.count > 1 else {
            return false
        }
        
        if let isTransitioning = nav.value(forKey: SJAssociatedKeys.k_isTransitioning) as? Bool, isTransitioning == true {
            return false
        }
        
        if ( nav.topViewController!.sj_disableFullscreenGesture ) {
            return false
        }
        
        if _blindAreaContains(nav, touch.location(in: nav.view)) {
            return false
        }
        
        if let last = nav.children.last, last.isKind(of: UINavigationController.self) {
            return false
        }
        
        if let webView = nav.topViewController!.sj_considerWebView {
            return !webView.canGoBack;
        }
        
        return true
    }

    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if SJFullscreenPopGesture.gestureType == .edgeLeft {
            return true
        }

        let gesture = gestureRecognizer as! UIPanGestureRecognizer
        
        let translate = gesture.translation(in: gesture.view)
        
        if ( translate.x > 0 && translate.y == 0 ) {
            return true
        }
        
        return false
    }
    
    // 全屏手势是否和other手势一起触发
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if ( gestureRecognizer.state == .failed ||
             gestureRecognizer.state == .cancelled ) {
            return false
        }

        if SJFullscreenPopGesture.gestureType == .edgeLeft {
            _cancelGesture(otherGestureRecognizer)
            return true
        }
        
        guard let view = gestureRecognizer.view else {
            return false
        }
        
        guard let nav = _lookupResponder(view, UINavigationController.self) else {
            return false
        }
        
        let location = gestureRecognizer.location(in: view)
        
        if _blindAreaContains(nav, location) {
            return false
        }

        // scroll view
        if ( otherGestureRecognizer.isMember(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) ||
             otherGestureRecognizer.isMember(of: NSClassFromString("UIScrollViewPagingSwipeGestureRecognizer")!) ) {

            if let scrollView = otherGestureRecognizer.view as? UIScrollView {
                return _shouldRecognizeSimultaneously(scrollView, nav.sj_fullscreenGesture, otherGestureRecognizer)
            }
        }
        
        if otherGestureRecognizer.view!.isKind(of: NSClassFromString("_MKMapContentView")!) || otherGestureRecognizer.isKind(of: NSClassFromString("UIWebTouchEventsGestureRecognizer")!) {
            
            if _edgeAreaContains(nav, location) {
                _cancelGesture(otherGestureRecognizer)
                return true
            }
            else {
                return false
            }
        }
        
        if otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            return false
        }
        
        return false
    }
    
    func _shouldRecognizeSimultaneously(_ scrollView: UIScrollView, _ gestureRecognizer: UIPanGestureRecognizer, _ otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // UIPageViewController
        if scrollView.isKind(of: NSClassFromString("_UIQueuingScrollView")!) {
            if ( scrollView.isDecelerating ) {
                return false
            }
            
            guard let pageVC = _lookupResponder(scrollView, UIPageViewController.self) else {
                return false
            }
            
            guard let dataSource = pageVC.dataSource else {
                return false
            }
            
            guard let topViewController = pageVC.viewControllers?.first else {
                return false
            }
            
            if dataSource.pageViewController(pageVC, viewControllerBefore: topViewController) != nil {
                return false
            }
            
            _cancelGesture(otherGestureRecognizer)
            
            return true
        }
        
        let translate = gestureRecognizer.translation(in: gestureRecognizer.view!)
        
        if ( 0 == scrollView.contentOffset.x + scrollView.contentInset.left
            && !scrollView.isDecelerating
            && translate.x > 0 && 0 == translate.y ) {
            
            _cancelGesture(otherGestureRecognizer)
            
            return true
        }
        
        return false
    }
    
    func _edgeAreaContains(_ nav: UINavigationController, _ point: CGPoint) -> Bool {
        let offset: CGFloat = 50
        let rect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: offset, height: nav.view.bounds.height))
        
        return _rectContains(nav, rect, point, false)
    }
    
    func _blindAreaContains(_ nav: UINavigationController, _ point: CGPoint) -> Bool {
        if let blindArea = nav.topViewController?.sj_blindArea {
            for rect in blindArea {
                if _rectContains(nav, rect, point, true) {
                    return true
                }
            }
        }
        
        if let blindAreaViews = nav.topViewController?.sj_blindAreaViews {
            for view in blindAreaViews {
                if _rectContains(nav, view.frame, point, true) {
                    return true
                }
            }
        }
    
        return false
    }
    
    func _rectContains(_ nav: UINavigationController, _ rect: CGRect, _ point: CGPoint, _ shouldConvertRect: Bool) -> Bool {
        var value = rect
        
        if shouldConvertRect {
            value = nav.topViewController!.view.convert(rect, to: nav.view)
        }
        
        return value.contains(point)
    }
    
    func _lookupResponder<T>(_ first: UIResponder, _ cls: T.Type) -> T? {
        var next: UIResponder? = first
        while next != nil && next?.isKind(of: cls as! AnyClass) == false {
            next = next?.next
        }
        return next as? T
    }
    
    func _cancelGesture(_ gesture: UIGestureRecognizer) {
        gesture.setValue(UIGestureRecognizer.State.cancelled.rawValue, forKey: "state")
    }
}

fileprivate class SJTransitionHandler {
    static let shared: SJTransitionHandler = SJTransitionHandler.init()
    
    let shift: CGFloat = -UIScreen.main.bounds.width * 0.382
    
    func push(_ nav: UINavigationController, _ viewController: UIViewController) {
        if let last = nav.children.last {
            viewController.sj_previousViewControllerSnapshot = SJSnapshot.init(target: last)
        }
    }
    
    func began(_ nav: UINavigationController, _ viewController: UIViewController, _ offset: CGFloat) {
        //
        guard let snapshot = viewController.sj_previousViewControllerSnapshot else {
            return
        }
        
        // keyboard
        nav.view.endEditing(true)
        nav.view.superview?.insertSubview(snapshot.rootView, belowSubview: nav.view)
        
        //
        snapshot.began()
        
        snapshot.rootView.transform = CGAffineTransform.init(translationX: self.shift, y: 0)
        
        if ( SJFullscreenPopGesture.transitionMode == .maskAndShifting ) {
            snapshot.maskView?.alpha = 1
            let width = snapshot.rootView.frame.width
            snapshot.maskView?.transform = CGAffineTransform.init(translationX: -(self.shift + width), y: 0)
        }
        
        //
        if let block = viewController.sj_viewWillBeginDragging {
            block(viewController)
        }
        
        changed(nav, viewController, offset)
    }
    
    func changed(_ nav: UINavigationController, _ viewController: UIViewController, _ offset: CGFloat) {
        //
        guard let snapshot = viewController.sj_previousViewControllerSnapshot else {
            return
        }

        //
        var value = offset
        if ( offset < 0 ) {
            value = 0;
        }
        
        //
        nav.view.transform = CGAffineTransform.init(translationX: value, y: 0)
        
        //
        let width = snapshot.rootView.frame.width
        let rate = offset / width

        snapshot.rootView.transform = CGAffineTransform.init(translationX: self.shift * ( 1 - rate ), y: 0)
        
        if ( SJFullscreenPopGesture.transitionMode == .maskAndShifting ) {
            snapshot.maskView?.alpha = 1 - rate
            snapshot.maskView?.transform = CGAffineTransform.init(translationX: -( self.shift + width ) + ( self.shift * rate ) + offset , y: 0 )
        }
        
        //
        if let block = viewController.sj_viewDidDrag {
            block(viewController)
        }
    }
    
    func completed(_ nav: UINavigationController, _ viewController: UIViewController, _ offset: CGFloat) {
        //
        guard let snapshot = viewController.sj_previousViewControllerSnapshot else {
            return
        }

        //
        let screenWidth = nav.view.frame.width
        let rate = offset / screenWidth
        let maxOffset = SJFullscreenPopGesture.maxOffsetToTriggerPop
        let shouldPop = rate > maxOffset
        var animDuration = CGFloat.init(0.25)
        if ( shouldPop == false ) {
            animDuration = animDuration * ( offset / (maxOffset * screenWidth) ) + 0.05;
        }
        
        UIView.animate(withDuration: TimeInterval(animDuration), animations: {
            if ( shouldPop == true ) {
                snapshot.rootView.transform = CGAffineTransform.identity
                snapshot.maskView?.transform = CGAffineTransform.identity
                snapshot.maskView?.alpha = 0.001
                
                nav.view.transform = CGAffineTransform.init(translationX: nav.view.frame.width, y: 0)
            }
            else {
                snapshot.maskView?.alpha = 1
                snapshot.maskView?.transform = CGAffineTransform.init(translationX: -(self.shift + screenWidth), y: 0)
                
                nav.view.transform = CGAffineTransform.identity
            }
        }) { (_) in
            snapshot.rootView.removeFromSuperview()
            snapshot.completed()
            
            if ( shouldPop == true ) {
                nav.view.transform = CGAffineTransform.identity
                nav.popViewController(animated: false)
            }
            if let block = viewController.sj_viewDidEndDragging {
                block(viewController)
            }
        }
    }
}

fileprivate class SJSnapshot {
    
    weak var target: UIViewController?
    
    var rootView: UIView
    
    var maskView: UIView?
    
    init(target: UIViewController) {
        // target
        self.target = target
        
        // nav
        let nav = target.navigationController!
        rootView = UIView.init(frame: nav.view.bounds)
        rootView.backgroundColor = UIColor.white
        
        // snapshot
        switch target.sj_displayMode {
        case .snapshot:
            // snapshaot
            if let snapshot = nav.view.superview?.snapshotView(afterScreenUpdates: false) {
                rootView.addSubview(snapshot)
            }
        case .origin:
            // nav bar snapshot
            if nav.isNavigationBarHidden == false {
                var rect = nav.view.convert(nav.navigationBar.frame, to: nav.view.window)
                rect.size.height += rect.origin.y + 1;
                rect.origin.y = 0;
                if let snapshot = nav.view.superview?.resizableSnapshotView(from: rect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero) {
                    snapshot.frame = rect
                    rootView.addSubview(snapshot)
                }
            }
            
            // tab bar snapshot
            if let tabBar = nav.tabBarController?.tabBar, tabBar.isHidden == false {
                var rect = tabBar.convert(tabBar.bounds, to: nav.view.window)
                rect.origin.y -= 1
                rect.size.height += 1
                if let snapshot = nav.view.window?.resizableSnapshotView(from: rect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero) {
                    snapshot.frame = rect
                    rootView.addSubview(snapshot)
                }
            }
        }
        
        // mask
        if ( SJFullscreenPopGesture.transitionMode == .maskAndShifting ) {
            maskView = UIView.init(frame: rootView.bounds)
            maskView?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.8)
            rootView.addSubview(maskView!)
        }
    }
    
    func began() {
        if let vc = target, vc.sj_displayMode == .origin {
            rootView.insertSubview(vc.view, at: 0)
        }
    }
    
    func completed() {
        guard let vc = target else {
            return
        }
        
        if ( vc.sj_displayMode == .origin && vc.view.superview == rootView ) {
            vc.view.removeFromSuperview()
        }
    }
}

fileprivate struct SJAssociatedKeys {
    static var kSJTookOver = "kSJTookOver"
    static var kSJDisplayMode = "kSJDisplayMode"
    static var kSJSnapshot = "kSnapshot"
    static var ksj_viewWillBeginDragging = "sj_viewWillBeginDragging"
    static var ksj_viewDidDrag = "sj_viewDidDrag"
    static var ksj_viewDidEndDragging = "sj_viewDidEndDragging"
    static var ksj_disableFullscreenGesture = "sj_disableFullscreenGesture"
    static var ksj_considerWebView = "ksj_considerWebView"
    static var ksj_blindArea = "ksj_blindArea"
    static var ksj_blindAreaViews = "ksj_blindAreaViews"
    
    static var k_isTransitioning = "_isTransitioning"
    static var k_FullscreenGesture = "k_FullscreenGesture"
}
