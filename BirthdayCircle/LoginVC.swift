//
//  LoginVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/9.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var rowHeight:CGFloat = 44.0
    var rowImgHeight: CGFloat = 25.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.tableView.rowHeight = self.rowHeight
        self.tableView.dataSource = self
        self.tableView.delegate = self
        

        
        
        self.view.addSubview(tableView)
        layout(tableView) { tableView in
            tableView.edges == tableView.superview!.edges
            return
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let imgView = UIImageView()
            cell.contentView.addSubview(imgView)
            let textField = UITextField()
            cell.contentView.addSubview(textField)
            
            layout(imgView, textField) { imgView, textField in
                imgView.centerY == imgView.superview!.centerY
                imgView.height == self.rowImgHeight
                imgView.width == self.rowImgHeight
                imgView.leading == imgView.superview!.leading + 6
                
                textField.centerY == textField.superview!.centerY
                textField.height == textField.superview!.height
                textField.leading == imgView.trailing + 3
                textField.trailing == textField.superview!.trailing - 3
            }
            
            switch indexPath.row {
            case 0:
                imgView.image = UIImage(named: "ic_phone_small")
                textField.placeholder = "手机号"
                textField.keyboardType = UIKeyboardType.PhonePad
            case 1:
                imgView.image = UIImage(named: "ic_password")
                textField.placeholder = "密码"
                textField.secureTextEntry = true
            default:
                break
        
            }
        } else {
            let label = UILabel()
            label.text = "登入"
            label.sizeToFit()
            cell.contentView.addSubview(label)
            
            layout(label) { label in
                label.center == label.superview!.center
                return
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return footerView()
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
}





















