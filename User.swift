//
//  BirthdayCircle.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/14.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import Foundation
import CoreData


@objc(User)
class User: NSManagedObject {

    @NSManaged var phone: String?
    @NSManaged var uid: NSNumber?
    @NSManaged var portrait: String?
    @NSManaged var birthday: String?
    @NSManaged var username: String?
    @NSManaged var alarm: String?
    @NSManaged var portraitBig: String?
    @NSManaged var sex: String?
    @NSManaged var birthplace: String?

    func fillWithJSON(json: JSON) {
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
