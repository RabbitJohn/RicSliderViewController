//
//  RicMenuViewController.swift
//  Pods
//
//  Created by 张礼焕 on 2016/12/25.
//
//

import UIKit


open class RicMenuTableViewController: UIViewController {

    
    public let tableView:UITableView = UITableView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.frame = UIScreen.main.bounds
        self.view.backgroundColor = .lightGray
        self.tableView.backgroundColor = UIColor.yellow
        self.view.addSubview(self.tableView)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
