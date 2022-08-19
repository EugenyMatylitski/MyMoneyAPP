//
//  TabBarController.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 2.08.22.
//

import Foundation
import UIKit

final class TabBarController : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
