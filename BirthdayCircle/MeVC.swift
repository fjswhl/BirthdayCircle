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
            row.action.viewControllerClass = AccountSettingVC.self
        }
        img = UIImage(named: "ic_account_setting")
        row["imageView.image"] = img!
        
        section.addFormRow(row)
        
        self.form = form
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我"
        initializeProfile()
        
        
        /**
        *  接收用户登入或注销的通知，并相应更改表视图
        */
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(USER_DID_LOGIN_NOTIFICATION, object: nil)
            .takeUntil(self.rac_willDeallocSignal())
            .subscribeNext { (_) -> Void in
                
            self.form.removeFormRowWithTag("me")
            let section = self.form.formSections[0] as XLFormSectionDescriptor
            var row = self.rowForUserDidLogin()
            section.addFormRow(row)
                
            row = self.form.formRowWithTag(AC_SETTING_ROW_KEY)
            row.action.viewControllerClass = AccountSettingVC.self
            self.initializeProfile()
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(USER_DID_LOGOUT_NOTIFICATION, object: nil)
            .takeUntil(self.rac_willDeallocSignal())
            .subscribeNext { (_) -> Void in
    
            self.form.removeFormRowWithTag("me")
            let section = self.form.formSections[0] as XLFormSectionDescriptor
            section.addFormRow(self.rowForUserNotLogin())
                
            var row = self.form.formRowWithTag(AC_SETTING_ROW_KEY)
            row.action.viewControllerClass = LoginVC.self
        }
        
        
//        /**
//            下拉刷新
//        */
//        self.tableView.addPullToRefreshWithActionHandler {
//            UserProfileService.sharedProfile.loadProfileFromRemote({ (userProfile) -> Void in
//                self.tableView.pullToRefreshView.stopAnimating()
//            })
//        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

    }
    

    /**
    如果用户登入了，获取个人信息
    
    */
    func initializeProfile() {
        if NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_KEY) {
            let pfs = UserProfileService.sharedProfile
            pfs.fetchProfile({ (user) -> Void in
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
    
    // MARK: Helper
    
    func rowForUserDidLogin() -> XLFormRowDescriptor {
        var row = XLFormRowDescriptor()
        row.tag = "me"
        row.cellClass = MeCell.self
        row.action.viewControllerClass = UpdateProfileVC.self
        row["birthdayLabel.text"] = "未设置"

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

        RACObserve(UserProfileService.sharedProfile.profile!, "username").subscribeNext { (object) -> Void in
            row["nameLabel.text"] = object as String

        }
        RACObserve(UserProfileService.sharedProfile.profile!, "birthday").subscribeNext { (object) -> Void in
            row["birthdayLabel.text"] = object as String
            self.tableView.reloadData()
        }
        RACObserve(UserProfileService.sharedProfile.profile!, "imageData").subscribeNext { (object) -> Void in
            if let data = object as? NSData {
                row["avatarImgView.image"] = UIImage(data: data)
                self.tableView.reloadData()

            }
        }
        request(.GET, UserProfileService.sharedProfile.profile!.portrait!, parameters: nil)
            .response { (req, res, data, err) -> Void in
                if res != nil {
                    if let user = User.currentUser() {
                        println(req)
                        let imageData = data as? NSData
                        if let image = UIImage(data: imageData!) {
                            user.imageData = imageData
                        }
                        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    }
                }
        }
    }
}

















