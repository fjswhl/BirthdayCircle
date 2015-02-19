//
//  UpdateProfileVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/14.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit
import AssetsLibrary
import MobileCoreServices

private let _avatarRowTag = "avatar"

class UpdateProfileVC: XLFormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveProfile")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        let form = XLFormDescriptor(title: "个人信息")
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
        row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeSelectorPush, title: "姓名")
        row.action.viewControllerClass = InputNameVC.self
        row.value = UserProfileService.sharedProfile.profile!.username
        section.addFormRow(row)
        row = XLFormRowDescriptor(tag: "sex", rowType: XLFormRowDescriptorTypeSelectorPush, title: "性别")
        row.selectorOptions = [XLFormOptionsObject(value: "man", displayText: "男"),
                               XLFormOptionsObject(value: "woman", displayText: "女")]
        row.required = true
        row.value = UserProfileService.sharedProfile.profile!.sex != "" ? UserProfileService.sharedProfile.profile!.sex : "未设置"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "birthday", rowType: XLFormRowDescriptorTypeDateInline, title: "生日")
        row.value = NSDate()
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "birthplace", rowType: XLFormRowDescriptorTypeCityInline, title: "出生地")
        row.value = UserProfileService.sharedProfile.profile!.birthplace != "" ?  UserProfileService.sharedProfile.profile!.birthplace : "未设置"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "phone", rowType: XLFormRowDescriptorTypeInfo, title: "手机")
        row.value = UserProfileService.sharedProfile.profile!.phone
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }

    /**
    先存进数据库，再 POST 到服务器
    */
    func saveProfile() {
        println(self.form.formValues())
        
        let formValues = self.httpParameters()
        
        let date = formValues["birthday"] as NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        let dateString = dateFormatter.stringFromDate(date)
        let birthplace = formValues["birthplace"] as String
        let username = formValues["name"] as String
        var sex = formValues["sex"] as String

        let webSh = WebServicesHandler.sharedHandler
        
        webSh.updateProfile(birthday: dateString, birthplace: birthplace, username: username, sex: sex) { (data) -> Void in
            println(data)
            UserProfileService.sharedProfile.loadProfileFromRemote(nil)
        }
        
        if let imgURLString = formValues["avatar"] as? String {
            webSh.updatePortrait(NSURL(string: imgURLString)!, handler: { (data) -> Void in
                println(data)
            })
        }

    }
    
    
    
    // MARK: 选取头像相关方法
    
    func takeAvatarFromLibrary() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("拍照")
        actionSheet.addButtonWithTitle("从手机相册选择")
        actionSheet.showInView(self.view)
    }
    

    
    override func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        actionSheet.dismissWithClickedButtonIndex(buttonIndex, animated: true)
    }
    
    override func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        switch buttonIndex {
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        case 2:
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        default:
            break;
        }
        if buttonIndex != actionSheet.cancelButtonIndex {
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as UIImage
        let row = self.form.formRowWithTag(_avatarRowTag)
        
        // save to disk
        let documentURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL
        let imgURL = documentURL.URLByAppendingPathComponent("portrait.png")
        let imgData = UIImagePNGRepresentation(image)
        imgData.writeToURL(imgURL, atomically: true)
        row.value = imgURL.URLString
        
        
        picker.dismissViewControllerAnimated(true, completion: { [weak self] () -> Void in
            row["avatarImgView.image"] = image
            self!.tableView.reloadData()
        })
        

    }

}










