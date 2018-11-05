//
//  TestViewControllerNav.swift
//  SwiftVersion
//
//  Created by 畅三江 on 2018/2/25.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

import UIKit
import SJUIFactory

class TestViewControllerNav: UIViewController {

    private let pushBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("Push", for: .normal)
        btn.addTarget(self, action: #selector(push), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private let albumBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("Album", for: .normal)
        btn.addTarget(self, action: #selector(album), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private let modal_Nav_Btn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("modal_Nav", for: .normal)
        btn.addTarget(self, action: #selector(modal_Nav), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private let alertBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("Alert", for: .normal)
        btn.addTarget(self, action: #selector(alert), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    private var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sj_displayMode = .origin
        self.edgesForExtendedLayout = UIRectEdge()
        
        scrollView = UIScrollView.init()
        scrollView?.frame = self.view.bounds
        scrollView?.isPagingEnabled = true
        scrollView?.contentSize = CGSize.init(width: self.view.bounds.width * 3, height: self.view.bounds.height * 2);
        self.view.addSubview(scrollView!)
        
        for i in 0...2 {
            let scrollSubview = UIView.init()
            scrollSubview.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1)
            scrollSubview.frame = CGRect.init(x: self.view.bounds.width * CGFloat(i), y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            scrollView!.addSubview(scrollSubview)
        }
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Close", style: .plain, target: self, action: #selector(close))
        
        var frame = CGRect.init(x: 100, y: 200, width: 100, height: 30)
        
        self.view.addSubview(pushBtn)
        pushBtn.frame = frame
        
        frame.origin.y += frame.height + 10
        self.view.addSubview(albumBtn)
        albumBtn.frame = frame

        frame.origin.y += frame.height + 10
        self.view.addSubview(modal_Nav_Btn)
        modal_Nav_Btn.frame = frame
        
        frame.origin.y += frame.height + 10
        self.view.addSubview(alertBtn)
        alertBtn.frame = frame
        
       
        // Do any additional setup after loading the view.
    }

    deinit {
//        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func close() -> Void {
        if ( self.navigationController?.presentingViewController != nil ) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func push() -> Void {
        self.navigationController?.pushViewController(ViewControllerMapView(), animated: true)
    }
    
    
    @objc private func album() -> Void {
        SJUIImagePickerControllerFactory.shared().alterPickerViewController(with: self, alertTitle: nil, msg: nil, photoLibrary: { (image) in
            self.albumBtn.setBackgroundImage(image, for: .normal)
        }) { (image) in
            self.albumBtn.setBackgroundImage(image, for: .normal)
        }
    }
    
    @objc private func modal_Nav() -> Void {
        let nav = NavViewController.init(rootViewController: TestViewControllerNav())
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func alert() -> Void {
        let alertVC = UIAlertController.init(title: "Test", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}
