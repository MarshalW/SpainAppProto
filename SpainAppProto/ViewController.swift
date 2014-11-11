//
//  ViewController.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/6.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //前台视图
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var frontViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var frontViewWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var frontViewCenterYConstraint: NSLayoutConstraint!

    var gesture:UIPanGestureRecognizer?
    var pointStartX:CGFloat=0
    
    //后台视图
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gesture=UIPanGestureRecognizer(target: self, action: "handlePan:")
        frontView.addGestureRecognizer(gesture!)
        
        var view=UIView.loadFromNibNamed("FrontView")
        frontView.addSubview(view!)
        //TODO 编程实现autolayout
    }
    
    override func viewDidAppear(animated: Bool) {
        //设置前台视图约束
        frontViewHeightConstrant.constant=backView.frame.height
        frontViewWidthConstrant.constant=backView.frame.width
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        var p:CGPoint = recognizer.locationInView(self.view)
        
        switch recognizer.state{
        case .Began:
            pointStartX=p.x
            frontView.transform=CGAffineTransformMakeScale(0.7, 0.7)
            break
        case .Changed:
            var deltaX=pointStartX-p.x
            frontViewCenterYConstraint.constant=deltaX
            
            //TODO 根据移动的距离缩小 CGAffineTransformMakeScale
            
            break
        case .Ended:
            frontViewCenterYConstraint.constant=0;
            frontView.transform=CGAffineTransformMakeScale(1, 1)
            break
        default:
            "do nothing"
        }
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}

