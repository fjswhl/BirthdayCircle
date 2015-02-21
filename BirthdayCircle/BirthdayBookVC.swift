//
//  BirthdayBookVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/21.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

class BirthdayBookVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var searchController: UISearchDisplayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeUI() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addBirthday")
        
        self.title = "生日簿"
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        layout(tableView) { tableView in
            tableView.edges == tableView.superview!.edges; return
        }
        
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜索生日"
        tableView.tableHeaderView = searchBar
        self.searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        let index = (indexPath.section, indexPath.row)
        
        switch index {
        case (0, 0):
            cell.textLabel?.text = "发现生日"
        case (0, 1):
            cell.textLabel?.text = "添加生日"
        default:
            break
        }
        
        return cell
    }
    

}
