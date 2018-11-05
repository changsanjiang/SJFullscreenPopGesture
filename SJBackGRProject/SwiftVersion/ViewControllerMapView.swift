//
//  ViewControllerMapView.swift
//  SwiftVersion
//
//  Created by BlueDancer on 2018/11/5.
//  Copyright © 2018 SanJiang. All rights reserved.
//

import UIKit
import MapKit

class ViewControllerMapView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MKMapView.init(frame: self.view.bounds)
        self.view.addSubview(mapView)
        // Do any additional setup after loading the view.
    }

}
