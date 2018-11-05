//
//  ViewControllerTestTableView.swift
//  SwiftVersion
//
//  Created by BlueDancer on 2018/11/5.
//  Copyright © 2018 SanJiang. All rights reserved.
//

import UIKit

class ViewControllerTestTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let UITableViewCellID: String = "UITableViewCell";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView.init(frame: self.view.frame, style: UITableViewStyle.plain)
        tableView.rowHeight = 49;
        tableView .register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCellID)
        self.view.addSubview(tableView)
        
        tableView.backgroundColor = .white;
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 99
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: UITableViewCellID, for: indexPath)
        cell.contentView.backgroundColor = UIColor.init(white: 0, alpha: CGFloat(arc4random() % 10) / 10.0)
        return cell
    }
}
