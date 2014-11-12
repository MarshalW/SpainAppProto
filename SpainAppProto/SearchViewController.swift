//
//  SearchViewController.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/12.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func popBack(sender: AnyObject) {
        ApplicationContext.popBack()
    }
}
