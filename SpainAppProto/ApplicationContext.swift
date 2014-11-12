//
//  ApplicationContext.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/12.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit

class ApplicationContext: NSObject {
    //单例模式，如果需要可用
    //参考了：http://stackoverflow.com/questions/24024549/dispatch-once-singleton-model-in-swift
    class var sharedInstance:ApplicationContext{
        struct Singleton{
            static let instance=ApplicationContext()
        }
        
        return Singleton.instance
    }
    
    class func test(){
        println("hello fro app context")
    }
    
    class func pushToState(stateName:String,parameters:[String:AnyObject]?=nil, delayTime:Double=0){
        delay(delayTime){
            NSNotificationCenter.defaultCenter().postNotificationName("pushToState", object: self, userInfo:["state":stateName])
        }
    }
    
    class func popBack(delayTime:Double=0){
        delay(delayTime){
            NSNotificationCenter.defaultCenter().postNotificationName("popBack", object: self, userInfo:nil)
        }
    }
    
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
