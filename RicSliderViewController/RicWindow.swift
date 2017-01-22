//
//  RicWindow.swift
//  Pods
//
//  Created by 张礼焕 on 2016/12/25.
//
//

import UIKit

open class RicWindow: UIWindow {
    
    fileprivate let bottomVC:UIViewController = UIViewController.init()
    fileprivate let menuViewController:RicMenuViewController = RicMenuViewController()
    fileprivate let topVC:RicSliderViewController = RicSliderViewController()
    
    open var enableSlider:Bool = true
    
    public static let mainWindow:RicWindow = RicWindow()
    
    public override init(frame: CGRect){
        super.init(frame: UIScreen.main.bounds)
        self.rootViewController = self.bottomVC
        self.addSubViews()
        self.setUpContentViewFrame(self.bounds)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RicWindow{
    fileprivate func addSubViews(){
        self.bottomVC.view.addSubview(self.menuViewController.view)
        self.bottomVC.view.addSubview(self.topVC.view)
    }
    fileprivate func setUpContentViewFrame(_ frame:CGRect)
    {
        self.menuViewController.view.frame = self.bounds
        self.topVC.view.frame = self.bounds
    }
    fileprivate func setSubBgColors(){
        self.menuViewController.view.backgroundColor = UIColor.red
        self.topVC.view.backgroundColor = UIColor.yellow
    }
}
