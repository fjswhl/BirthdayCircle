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
    
    var userDidLogin: Bool = NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_LEY)
    var userProfile: UserProfile!
    
    override init() {
        super.init()
        initializeProfile()
        initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeProfile()
        initializeForm()

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeProfile()
        initializeForm()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userDidLogin = NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_LEY)
        var row = self.form.formRowWithTag(AC_SETTING_ROW_KEY)
        if self.userDidLogin {
            row.action.viewControllerClass = AccountSetting.self
        } else {
            row.action.viewControllerClass = LoginVC.self
        }
    }
    
    func initializeForm() {
        let form = XLFormDescriptor()
        var section = XLFormSectionDescriptor()
        
        form.addFormSection(section)
        var row = XLFormRowDescriptor(tag: "Me", rowType: XLFormRowDescriptorTypeButton, title: "尚未登入")
        if userDidLogin == false {
            row.action.viewControllerClass = LoginVC.self
        }
        var img = UIImage(named: "ic_user_not_login")
        row.cellConfig.setObject(img!, forKey: "imageView.image")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "memory", rowType: XLFormRowDescriptorTypeButton, title: "美好回忆")
        row.action.viewControllerClass = MoreVC.self
        img = UIImage(named: "ic_memory")
        row.cellConfig.setObject(img!, forKey: "imageView.image")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "more", rowType: XLFormRowDescriptorTypeButton, title: "更多")
        row.action.viewControllerClass = MoreVC.self
        img = UIImage(named: "ic_settings")
        row.cellConfig.setObject(img!, forKey: "imageView.image")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: AC_SETTING_ROW_KEY, rowType: XLFormRowDescriptorTypeButton, title: "账户设置")
        if userDidLogin == false {
            row.action.viewControllerClass = LoginVC.self
        } else {
            row.action.viewControllerClass = AccountSetting.self
        }
        img = UIImage(named: "ic_account_setting")
        row.cellConfig.setObject(img!, forKey: "imageView.image")
        section.addFormRow(row)
        
        self.form = form
    }
    
    func initializeProfile() {
        if self.userDidLogin {
            let pfs = UserProfileService.sharedProfile
            pfs.fetchProfile({ (userProfile) -> Void in
                self.userProfile = userProfile
            })
        }
    }

    
}

















