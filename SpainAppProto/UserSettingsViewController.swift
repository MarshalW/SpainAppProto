//
//  UserSettingsViewController.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/12.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {

    @IBAction func popBack(sender: UIButton) {
        ApplicationContext.popBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
