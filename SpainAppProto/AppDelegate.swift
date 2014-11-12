//
//  AppDelegate.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/6.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var navigationController:UINavigationController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushToState:", name: "pushToState", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popBack:", name: "popBack", object: nil)
        
        navigationController=self.window?.rootViewController as UINavigationController!
        
        return true
    }
    
    func pushToState(notification:NSNotification){
        let state:String = notification.userInfo?["state"] as NSString
        
        //http://stackoverflow.com/questions/24570345/nsclassfromstring-always-returns-nil
        let xibName=state+"ViewController"
        let controllerName="SpainAppProto."+xibName

        var classType: AnyObject.Type=NSClassFromString(controllerName)
        var nsobjectype : UIViewController.Type = classType as UIViewController.Type
        var viewController: UIViewController = nsobjectype(nibName: xibName, bundle: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popBack(notification:NSNotification){
        navigationController?.popViewControllerAnimated(true)
    }
}
