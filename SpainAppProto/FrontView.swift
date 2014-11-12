//
//  FrontView.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/7.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit

class FrontView: UIView {
    
    dynamic var open=false
    dynamic var openTime=NSDate()
    
    @IBAction func openMenu(sender: UIButton) {
        if !open{
            open=true
            openTime=NSDate()
        }
        

    }
    @IBAction func search(sender: AnyObject) {
        ApplicationContext.pushToState("Search")
    }
}
