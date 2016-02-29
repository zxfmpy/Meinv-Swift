//
//  MNBaseController.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/2/29.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import UIKit

class MNBaseController: UIViewController {

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.279, green:0.284, blue:0.293, alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
}
