//
//  LoginVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/9.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit


let USER_DID_LOGIN_NOTIFICATION = "USER_DID_LOGIN_NOTIFICATION"

class LoginVC: XLFormViewController {
    
    let loginButtonFontSize = 18.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init() {
        super.init()
        initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initializeForm() {
        let form = XLFormDescriptor(title: "登入")
        var section = XLFormSectionDescriptor()
        
        form.addFormSection(section)
        var row = XLFormRowDescriptor(tag: "phone", rowType: XLFormRowDescriptorTypePhone, title: "手机号：")

        row.cellConfig.setObject("请输入生日圈手机号", forKey: "textField.placeholder")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "pwd", rowType: XLFormRowDescriptorTypePassword, title: "密　码：")
        row.cellConfig.setObject("请输入登入密码", forKey: "textField.placeholder")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "login", rowType: XLFormRowDescriptorTypeButton, title: "登入")
        row.action.formSelector = "signIn"
        row.cellConfig.setObject(HexUIColor("ff6622"), forKey: "backgroundColor")
        let view = UIView()
        view.backgroundColor = HexUIColor("ff4400")
        row.cellConfig.setObject(view, forKey: "selectedBackgroundView")
        row.cellConfig.setObject(UIColor.whiteColor(), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIFont.systemFontOfSize(18.0), forKey: "textLabel.font")
        section.addFormRow(row)
        
        self.form = form
    }

    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return footerView()
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 80
        }
        return 0
    }
    
    func footerView() -> UIView {
        let view = UIView()

        let signUpButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        signUpButton.setTitle("立即注册", forState: UIControlState.Normal)
        signUpButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        signUpButton.addTarget(self, action: "signUp:", forControlEvents: UIControlEvents.TouchUpInside)
        signUpButton.sizeToFit()
        
        let forgetPwdButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        forgetPwdButton.setTitle("忘记密码", forState: UIControlState.Normal)
        forgetPwdButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        forgetPwdButton.addTarget(self, action: "forgetPwd", forControlEvents: UIControlEvents.TouchUpInside)
        forgetPwdButton.sizeToFit()
        
        view.addSubview(signUpButton)
        view.addSubview(forgetPwdButton)
        
        layout(signUpButton, forgetPwdButton) { signUpButton, forgetPwdButton in
            signUpButton.top == signUpButton.superview!.top + 5
            signUpButton.leading == signUpButton.superview!.leading + 5
            
            forgetPwdButton.top == forgetPwdButton.superview!.top + 5
            forgetPwdButton.trailing == forgetPwdButton.superview!.trailing - 5
            
        }
        return view
    }
    
    // MARK: Button Method
    
    func signUp(sender: UIButton!) {
        let signUpVC = SignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func signIn() {

        let phone = self.formValues()["phone"] as String
        let pwd = self.formValues()["pwd"] as String
        let webSH = WebServicesHandler.sharedHandler
        
        SVProgressHUD.show()
        
        webSH.signin(phone: phone, pwd: pwd) { (data) -> Void in
            SVProgressHUD.dismiss()
            if let uid = data["success"].int {
                println("登入成功 uid：\(uid)")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: USER_DID_LOGIN_KEY)
                NSUserDefaults.standardUserDefaults().setObject(phone, forKey: USER_PHONE_KEY)
                NSUserDefaults.standardUserDefaults().setObject(pwd, forKey: USER_PWD_KEY)
                
                NSNotificationCenter.defaultCenter().postNotificationName(USER_DID_LOGIN_NOTIFICATION, object: nil)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                println("帐号或密码不正确")
            }
        }
    }

}





















