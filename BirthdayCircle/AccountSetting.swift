//
//  AccountSetting.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/11.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

let USER_DID_LOGOUT = "USER_DID_LOGOUT"

class AccountSetting: XLFormViewController {
    
    var profile: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init() {
        super.init()
        if let p = UserProfileService.sharedProfile.profile {
            self.profile = p
        } else {
            UserProfileService.sharedProfile.fetchProfile({ (User) in
                self.profile = User
            })
        }
        initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
   

    func initializeForm() {
        let form = XLFormDescriptor()
        var section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        var row = XLFormRowDescriptor(tag: "acid", rowType: XLFormRowDescriptorTypeInfo, title: "账户ID")

        row.cellConfig.setObject(String(self.profile.uid!.integerValue), forKey: "detailTextLabel.text")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "logac", rowType: XLFormRowDescriptorTypeInfo, title: "登入帐号")
        row.cellConfig.setObject(profile.phone!, forKey: "detailTextLabel.text")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "mopwd", rowType: XLFormRowDescriptorTypeButton, title: "修改密码")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "mophone", rowType: XLFormRowDescriptorTypeButton, title: "修改手机号")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "bir", rowType: XLFormRowDescriptorTypeSelectorPush, title: "生日秘密")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "remind", rowType: XLFormRowDescriptorTypeTimeInline, title: "提醒时间设置")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "logout", rowType: XLFormRowDescriptorTypeButton, title: "退出登入")
        row.action.formSelector = "logout"
        section.addFormRow(row)
        
        self.form = form
    }
    
    
    
    func logout() {
        let webSH = WebServicesHandler.sharedHandler
        webSH.logout { (data) -> Void in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: USER_DID_LOGIN_KEY)
            self.navigationController?.popViewControllerAnimated(true)
            println("用户注销")
            
            NSNotificationCenter.defaultCenter().postNotificationName(USER_DID_LOGOUT, object: nil)
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
}







