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
        // Tabbar Item
        let simg = UIImage(named: "tab2_2")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.selectedImage = simg
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addBirthday")
        
        self.title = "生日簿"
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        layout(tableView) { tableView in
            tableView.edges == tableView.superview!.edges; return
        }
        
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.navigationController!.navigationBar.frame.height, height: 44))
        searchBar.placeholder = "搜索生日"
        tableView.tableHeaderView = searchBar
        self.searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
    }
    
//    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        <#code#>
//    }
    
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
            cell.imageView?.image = UIImage(named: "ic_add_contact")
        case (0, 1):
            cell.textLabel?.text = "添加生日"
            cell.imageView?.image = UIImage(named: "ic_find")
        default:
            break
        }
        
        return cell
    }
    
    // MARK: right bar button method
    
    func addBirthday() {
        let nav = UINavigationController(rootViewController: AddBirthdayVC())
        self.presentViewController(nav, animated: true, completion: nil)
    }
    

}
