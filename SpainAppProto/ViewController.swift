//
//  ViewController.swift
//  SpainAppProto
//
//  Created by Marshal Wu on 14/11/6.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

import UIKit
import Snappy

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    //前台视图
    @IBOutlet weak var frontView: UIView!
    var innerFrontView:FrontView!
    @IBOutlet weak var frontViewHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var frontViewWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var frontViewCenterYConstraint: NSLayoutConstraint!

    //滑动屏幕操作菜单手势
    var gesture:UIPanGestureRecognizer?
    var pointStartX:CGFloat=0
    
    //点击手势，用于收回菜单
    var tapGesture:UITapGestureRecognizer?
    
    //后台视图
    @IBOutlet weak var backView: UIView!
    
    //菜单视图
    @IBOutlet weak var menuView: UIView!
    var innerMenuView:MenuView!
    @IBOutlet weak var menuViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuViewCenterXConstraint: NSLayoutConstraint!
    
    var openMenu:Bool=false
    var endCenterX:CGFloat!
    let endScale:CGFloat=0.7
    
    var deltaX:CGFloat=0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置pan手势，打开关闭菜单
        gesture=UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view.addGestureRecognizer(gesture!)
        
        //设置点击手势，关闭菜单
        tapGesture=UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view.addGestureRecognizer(tapGesture!)
        tapGesture?.delegate=self
        
         //设置frontView内部view，包括布局
        innerFrontView=UIView.loadFromNibNamed("FrontView") as FrontView
        frontView.addSubview(innerFrontView)
        
        let padding = UIEdgeInsetsMake(0, 0, 0, 0)
        innerFrontView.snp_makeConstraints { make in //autolayout
            make.edges.equalTo(self.frontView).with.insets(padding)
            return
        }
        
        innerFrontView.addObserver(self, forKeyPath: "openTime", options: .New, context:nil)
        
        //设置菜单内的视图
        innerMenuView=UIView.loadFromNibNamed("MenuView") as MenuView
        menuView.addSubview(innerMenuView)
        
        innerMenuView.snp_makeConstraints { make in //autolayout
            make.edges.equalTo(self.menuView).with.insets(padding)
            return
        }

        innerMenuView.addObserver(self, forKeyPath: "triggerTime", options: .New, context:nil)
        
    }
    
    //识别tap是否符合要求的区域
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
       return touch.view==self.backView
    }
    
    func handleTap(recognizer:UITapGestureRecognizer) {
        closeMenuWithAnimate()
    }
    
    override func viewDidAppear(animated: Bool) {
        //设置前台视图约束
        frontViewHeightConstrant.constant=backView.frame.height
        frontViewWidthConstrant.constant=backView.frame.width
        
        //设置菜单视图约束
        menuViewHeightConstraint.constant=backView.frame.height
        menuViewWidthConstraint.constant=backView.frame.width
        
        endCenterX=backView.frame.width*3/5*(-1)
        
        //菜单初始位置
        menuViewCenterXConstraint.constant=backView.frame.width/4 //临时性的数值
        menuView.transform=CGAffineTransformMakeScale(endScale, endScale)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        //点击按钮后打开菜单
        if keyPath=="openTime"{
            openMenuWithAnimate()
            innerFrontView.open=false
        }
        
        //触发菜单项，关闭菜单
        if keyPath=="triggerTime"{
            closeMenuWithAnimate()
            innerMenuView.trigger=false
        }
    }
    
    deinit{
       innerFrontView.removeObserver(self, forKeyPath: "openTime")
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        var p:CGPoint = recognizer.locationInView(self.view)
        
        switch recognizer.state{
        case .Began:
            deltaX=0
            pointStartX=p.x
            break
        case .Changed:
            deltaX=pointStartX-p.x

            if(!openMenu && deltaX>0){//不能向左移动
                break
            }
            
            if(openMenu && deltaX<0){//不能向右移动
                break
            }
            
            if(deltaX<endCenterX){//向右移动的极限
                deltaX=endCenterX
            }
            
            if(deltaX>(-endCenterX)){//向左移动的极限
                deltaX=(-endCenterX)
            }
            
            //如果已经打开菜单，调整偏移量
            if openMenu{
                deltaX+=endCenterX
            }
            
            frontViewCenterYConstraint.constant=deltaX
            
            let scale=((endScale-1)/endCenterX)*deltaX+1
            frontView.transform=CGAffineTransformMakeScale(scale, scale)
            
            let menuScale=endScale+(1-scale)
            menuView.transform=CGAffineTransformMakeScale(menuScale,menuScale)
            
            break
        case .Ended:
            if(self.deltaX>endCenterX/2){
                frontViewCenterYConstraint.constant=0
                self.openMenu=false;
                self.frontView.userInteractionEnabled=true
            }else{
                frontViewCenterYConstraint.constant=endCenterX
                self.openMenu=true
                self.frontView.userInteractionEnabled=false
            }
            
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.TransitionNone, animations: ({
                if(self.deltaX>self.endCenterX/2){
                    self.frontView.transform=CGAffineTransformMakeScale(1, 1)
                    self.menuView.transform=CGAffineTransformMakeScale(self.endScale, self.endScale)
                    self.view.layoutIfNeeded()
                }else{
                    self.frontView.transform=CGAffineTransformMakeScale(self.endScale, self.endScale)
                    self.menuView.transform=CGAffineTransformMakeScale(1, 1)
                    self.view.layoutIfNeeded()
                }
                
            }), completion: nil)
            
            break
        default:
            "do nothing"
        }
    }
    
    func openMenuWithAnimate(){
        frontViewCenterYConstraint.constant=endCenterX
        self.openMenu=true
        self.frontView.userInteractionEnabled=false
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.TransitionNone, animations: ({
            
            self.frontView.transform=CGAffineTransformMakeScale(self.endScale, self.endScale)
            self.menuView.transform=CGAffineTransformMakeScale(1, 1)
            self.view.layoutIfNeeded()
            
        }), completion: nil)
    }
    
    func closeMenuWithAnimate(){
        frontViewCenterYConstraint.constant=0
        self.openMenu=false
        self.frontView.userInteractionEnabled=true
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.TransitionNone, animations: ({
            
            self.frontView.transform=CGAffineTransformMakeScale(1, 1)
            self.menuView.transform=CGAffineTransformMakeScale(self.endScale, self.endScale)
            self.view.layoutIfNeeded()
            
        }), completion: nil)
    }
}

extension UIView { //简化xib加载
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}

