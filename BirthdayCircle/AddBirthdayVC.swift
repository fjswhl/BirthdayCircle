//
//  AddBirthdayVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/22.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

private let _avatarRowTag = "avatar"

class AddBirthdayVC: XLFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "save")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
        let form  = XLFormDescriptor(title: "添加生日")
        self.form = form
        var section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        var row = XLFormRowDescriptor()
        row.title = "头像"
        row["textLabel.textAlignment"] = NSTextAlignment.Left.rawValue
        row.tag = _avatarRowTag
        row.cellClass = UpdateAvatarCell.self
        row.action.formSelector = "takeAvatarFromLibrary"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "phone", rowType: XLFormRowDescriptorTypePhone, title: "手机")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeName, title: "姓名")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "birthday", rowType: XLFormRowDescriptorTypeDateInline, title: "生日")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "relation", rowType: XLFormRowDescriptorTypeSelectorPush, title: "关系")
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "remind", rowType: XLFormRowDescriptorTypeSelectorPush, title: "提醒设置")
        section.addFormRow(row)

        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "other", rowType: XLFormRowDescriptorTypeSelectorPush, title: "其他")
        section.addFormRow(row)
    }

    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func save() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
