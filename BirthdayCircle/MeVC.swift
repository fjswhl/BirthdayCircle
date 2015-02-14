//
//  MeVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/9.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit


private let AC_SETTING_ROW_KEY = "setting"

class MeVC: XLFormViewController {
    
    var user: User!
    
    override init() {
        super.init()
        initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我"
        initializeProfile()
        
        
        /**
        *  接收用户登入或注销的通知，并相应更改表视图
        */
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(USER_DID_LOGIN, object: nil)
            .takeUntil(self.rac_willDeallocSignal())
            .subscribeNext { (_) -> Void in
                
            self.form.removeFormRowWithTag("me")
            let section = self.form.formSections[0] as XLFormSectionDescriptor
            var row = self.rowForUserDidLogin()
            section.addFormRow(row)
                
            row = self.form.formRowWithTag(AC_SETTING_ROW_KEY)
            row.action.viewControllerClass = AccountSetting.self
            self.initializeProfile()
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(USER_DID_LOGOUT, object: nil)
            .takeUntil(self.rac_willDeallocSignal())
            .subscribeNext { (_) -> Void in
    
            self.form.removeFormRowWithTag("me")
            let section = self.form.formSections[0] as XLFormSectionDescriptor
            section.addFormRow(self.rowForUserNotLogin())
                
            var row = self.form.formRowWithTag(AC_SETTING_ROW_KEY)
            row.action.viewControllerClass = LoginVC.self
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    func initializeForm() {
        let form = XLFormDescriptor()
        var section = XLFormSectionDescriptor()

        form.addFormSection(section)
        var row = rowForUserDidLogin()
        if NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_KEY) == false {
            row = rowForUserNotLogin()
        }
        
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "memory", rowType: XLFormRowDescriptorTypeButton, title: "美好回忆")
        row.action.viewControllerClass = MoreVC.self
        var img = UIImage(named: "ic_memory")
        row.cellConfig.setObject(img!, forKey: "imageView.image")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "more", rowType: XLFormRowDescriptorTypeButton, title: "更多")
        row.action.viewControllerClass = MoreVC.self
        img = UIImage(named: "ic_settings")
        row.cellConfig.setObject(img!, forKey: "imageView.image")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: AC_SETTING_ROW_KEY, rowType: XLFormRowDescriptorTypeButton, title: "账户设置")
        if NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_KEY) == false {
            row.action.viewControllerClass = LoginVC.self
        } else {
            row.action.viewControllerClass = AccountSetting.self
        }
        img = UIImage(named: "ic_account_setting")
        row["imageView.image"] = img!
        
        section.addFormRow(row)
        
        self.form = form
    }
    
    
    /**
    如果用户登入了，获取个人信息，先从数据库取，没有的话从网络取
    
    */
    func initializeProfile() {
        if NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_KEY) {
            let pfs = UserProfileService.sharedProfile
            pfs.fetchProfile({ (user) -> Void in
                self.user = user
                self.setupLoggedRowInfo()
            })
        }
    }

    
    // MARK: TableView delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_KEY) && indexPath.section == 0 {
            return 80
        }
        return 44
    }
    
    // MARK: Helper
    func rowForUserDidLogin() -> XLFormRowDescriptor {
        var row = XLFormRowDescriptor()
        row.tag = "me"
        row.cellClass = MeCell.self
        return row
    }
    
    func rowForUserNotLogin() -> XLFormRowDescriptor {
        var row = XLFormRowDescriptor(tag: "me", rowType: XLFormRowDescriptorTypeButton, title: "尚未登入")
        row.action.viewControllerClass = LoginVC.self
        var img = UIImage(named: "ic_user_not_login")
        row.cellConfig.setObject(img!, forKey: "imageView.image")
        
        return row
    }
    
    func setupLoggedRowInfo() {
        var row = self.form.formRowWithTag("me")
        row["nameLabel.text"] = self.user.username
        row["birthdayLabel.text"] = (self.user.birthday != "" ? self.user.birthday : "未设置")
        self.tableView.reloadData()
        request(.GET, self.user.portrait!, parameters: nil)
            .response { (req, res, data, err) -> Void in
                if res != nil {
            row["avatar"] = UIImage(data: data as NSData)
                    self.tableView.reloadData()
                }
        }
    }
}

















