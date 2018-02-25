//
//  ViewController.swift
//  SwiftVersion
//
//  Created by 畅三江 on 2018/2/24.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func push(_ sender: Any) {
        self.navigationController?.pushViewController(TestViewControllerNav(), animated: true)
    }
    
    
    @IBAction func alert(_ sender: Any) {
        let alertVC = UIAlertController.init(title: "Test", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

