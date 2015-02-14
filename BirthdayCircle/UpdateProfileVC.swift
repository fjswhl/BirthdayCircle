//
//  UpdateProfileVC.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/14.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

class UpdateProfileVC: XLFormViewController {

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
        let form = XLFormDescriptor()
        let section = XLFormSectionDescriptor()
        
        form.addFormSection(section)
        
    }

}
