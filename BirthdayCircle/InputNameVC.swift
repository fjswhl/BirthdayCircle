//
//  InputNameVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/14.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit


/**
*  一个非常无聊的 tableview，作为输入
*/
class InputNameVC: XLFormViewController, XLFormRowDescriptorViewController {

    var rowDescriptor: XLFormRowDescriptor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override init() {
        super.init()
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
        let section = XLFormSectionDescriptor()
        form.addFormSection(section)
        form.assignFirstResponderOnShow = true
        
        var row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeName)
        row["textField.text"] = UserProfileService.sharedProfile.profile!.username == "未填写" ? "" : UserProfileService.sharedProfile.profile!.username
        row["textField.placeholder"] = "用户名"
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.rowDescriptor.value = textField.text == "" ? "未填写" : textField.text
        self.navigationController?.popViewControllerAnimated(true)
        return false
    }
}






















