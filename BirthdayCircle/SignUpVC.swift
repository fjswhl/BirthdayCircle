//
//  SignUpVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/9.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var rowImgHeight:CGFloat = 25.0
    
    var inputedPhoneNumber: String?
    var inputedAuthCode: String?
    var inputedPwd: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        layout(tableView) { tableView in
            tableView.edges == tableView.superview!.edges
            return
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        return 1
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
                textField.placeholder = "11位手机号"
                textField.keyboardType = UIKeyboardType.PhonePad
                
                let btn = UIButton.buttonWithType(UIButtonType.System) as UIButton
                btn.setTitle("获取验证码", forState: UIControlState.Normal)
                btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                btn.addTarget(self, action: "getAuthCode", forControlEvents: UIControlEvents.TouchUpInside)
                cell.contentView.addSubview(btn)
                btn.sizeToFit()
                
                layout(btn) { btn in
                    btn.centerY == btn.superview!.centerY
                    btn.trailing == btn.superview!.trailing - 5
                }
            case 1:
                imgView.image = UIImage(named: "ic_phone_small")
                textField.placeholder = "手机验证码"
                textField.keyboardType = UIKeyboardType.NumberPad

            case 2:
                imgView.image = UIImage(named: "ic_password")
                textField.placeholder = "6-32位密码"
                textField.secureTextEntry = true
            default:
                break
            }
        } else {
            let label = UILabel()
            label.text = "注册"
            label.sizeToFit()
            cell.contentView.addSubview(label)
            
            layout(label) { label in
                label.center == label.superview!.center
                return
            }
        }
        return cell
    }
    
    
    // MARK:  Button Method
    func getAuthCode() {
        let webSH = WebServicesHandler.sharedHandler
        

    }
}















