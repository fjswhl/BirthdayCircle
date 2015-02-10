//
//  MeVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/9.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

class MeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我"
        
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(self.tableView)
        layout(tableView) { tableView in
            tableView.edges == tableView.superview!.edges
            return
        }

        
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "尚未登入"
            cell.imageView?.image = UIImage(named: "ic_user_not_login")
        case 1:
            cell.textLabel?.text = "美好回忆"
            cell.imageView?.image = UIImage(named: "ic_memory")
        case 2:
            cell.textLabel?.text = "更多"
            cell.imageView?.image = UIImage(named: "ic_settings")
        case 3:
            cell.textLabel?.text = "账户设置"
            cell.imageView?.image = UIImage(named: "ic_account_setting")
        default:
            break
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let loginVC = LoginVC()
            self.navigationController?.pushViewController(loginVC, animated: true)
        default:
            break
        }
    }
    
}

















