//
//  MoreVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/10.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

class MoreVC: XLFormViewController {
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
        var section = XLFormSectionDescriptor()
       
        form.addFormSection(section)
        var row = XLFormRowDescriptor(tag: "1", rowType: XLFormRowDescriptorTypeButton, title: "账户设置")
        section.addFormRow(row)

        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "2", rowType: XLFormRowDescriptorTypeButton, title: "分享给朋友")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "3", rowType: XLFormRowDescriptorTypeButton, title: "好评一下")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "4", rowType: XLFormRowDescriptorTypeButton, title: "意见反馈")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "5", rowType: XLFormRowDescriptorTypeButton, title: "版本更新")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "6", rowType: XLFormRowDescriptorTypeButton, title: "关于我们")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "7", rowType: XLFormRowDescriptorTypeButton, title: "服务协议")
        self.form = form
    }
    
    func test() {
        println("button tapped")
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}















