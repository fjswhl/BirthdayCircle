//
//  UserProfile.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/10.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

class UserProfile: NSObject {
    var phone: String?
    var uid: Int?
    var portrait: String?
    var birthday: String?
    var username: String?
    var alarm: String?
    var portraitBig: String?
    var sex: String?
    var birthplace: String?
    
    init(json: JSON) {
        super.init()
        
        phone = json["phone"].string
        uid = json["uid"].int
        portrait = json["portrait"].string
        birthday = json["birthday"].string
        username = json["username"].string
        alarm = json["alarm"].string
        portraitBig = json["portraitBig"].string
        sex = json["sex"].string
        birthplace = json["birthplace"].string
    }
}
