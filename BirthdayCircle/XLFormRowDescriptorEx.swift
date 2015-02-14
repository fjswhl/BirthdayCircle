//
//  XLFormRowDescriptorEx.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/13.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import Foundation

extension XLFormRowDescriptor {
    subscript (keyPath: String) -> AnyObject? {
        get {
            return self.cellConfig.objectForKey(keyPath)
        }
        
        set(newValue) {
            self.cellConfig.setObject(newValue!, forKey: keyPath)
        }
    }
}