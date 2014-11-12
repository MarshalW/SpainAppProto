//
//  MenuView.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/12.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    var trigger=false
    dynamic var triggerTime=NSDate()

    @IBAction func userSettings(sender: UIButton) {
        if !trigger{
            triggerTime=NSDate()
            ApplicationContext.pushToState("UserSettings")
        }
    }


}
