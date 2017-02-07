//
//  RicSliderViewController.swift
//  RicSliderViewController
//
//  Created by 张礼焕 on 2016/12/25.
//  Copyright © 2016年 rice. All rights reserved.
//

import UIKit

/// use this view controller as a root view controller.
open class RicSliderNavigationViewController: UINavigationController,UIGestureRecognizerDelegate {
    
    //the margin to the right border.
    public var toleranceOffsetToRightMargin:CGFloat = 80
    /// - Parameter vcs:
    fileprivate let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer()
    fileprivate var tapGesture:UITapGestureRecognizer?

    fileprivate var viewFrameOriX:CGFloat = 0
    fileprivate var oriX:CGFloat = 0
    fileprivate var offset:CGFloat = 0
    fileprivate var couldContinueGestureRecgnize:Bool = true
    fileprivate var isMoveToRight:Bool = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.addSlideOperation()
    }
    
    open func slideToRight(_ shouldSlideToRight:Bool){
        self.slideWithAnimation(shouldSlideToRight)
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Slider operation.
extension RicSliderNavigationViewController{
    
    fileprivate func addSlideOperation(){
        panGesture.addTarget(self
            , action: #selector(RicSliderNavigationViewController.tracePan(_:)))
        panGesture.delegate = self
        panGesture.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: nil)
        self.view.addGestureRecognizer(panGesture)
    }
    //
    @objc fileprivate func tracePan(_ panGes:UIPanGestureRecognizer){
        if(self.couldContinueGestureRecgnize == true && panGes.state != .ended){
            let velocity = panGes.velocity(in: RicWindow.mainWindow)
            self.isMoveToRight = velocity.x > 0
            let locationInWindow:CGFloat = CGFloat(panGes.location(in: RicWindow.mainWindow).x)
            // caculate the frame of the current VC's view and get the left margin. get the location of the finger in the window and minus the offset of the finger in the view as the the offset.
            offset = CGFloat(locationInWindow - oriX);
            //
            var caculatedX = max(viewFrameOriX + offset,0)
            
            caculatedX = min(caculatedX, self.getToleranceOffset())
            
            if(caculatedX < self.view.bounds.maxX){
                var frame:CGRect = self.view.frame
                frame.origin.x = caculatedX
                self.view.frame = frame
            }
        }
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if(gestureRecognizer == panGesture){
            viewFrameOriX = self.view.frame.minX
            oriX = CGFloat(panGesture.location(in: RicWindow.mainWindow).x)
        }
        return true
    }
    
    // two direction either right or left.
    public func slideWithAnimation(_ slideToRight:Bool){
        // do slide operation here
        UIView.setAnimationCurve(.linear)
        UIView.animate(withDuration: 0.15, animations: {
            if self.tapGesture == nil{
                self.tapGesture = UITapGestureRecognizer()
                self.tapGesture?.addTarget(self, action: #selector(RicSliderNavigationViewController.tapAction))
            }
            if(slideToRight == true){
                self.view.addGestureRecognizer(self.tapGesture!)
            }else{
                if (self.view.gestureRecognizers?.contains(self.tapGesture!))! == true{
                    self.view.removeGestureRecognizer(self.tapGesture!)
                }
            }
            self.view.frame.origin.x = slideToRight == true ? self.getToleranceOffset():0
        })
    }
    
    @objc private func tapAction(){
        if(self.isMoveToRight == true){
            self.slideWithAnimation(false)
        }else{
            self.slideWithAnimation(true)
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(object != nil ){
            let ges:UIPanGestureRecognizer = object as! UIPanGestureRecognizer
            if ges.state == .ended{
                self.couldContinueGestureRecgnize = false
                // 如果手势的状态是结束则执行下面这个操作。
                self.slideWithAnimation(self.isMoveToRight)
            }else if ges.state == .began{
                self.couldContinueGestureRecgnize = true
            }
        }
    }
    
}

extension RicSliderNavigationViewController:CAAnimationDelegate{
    
    fileprivate func getToleranceOffset()->CGFloat{
        let toteranceOffset = max(self.view.bounds.width - self.toleranceOffsetToRightMargin, 0)
        return toteranceOffset
    }
    
}



