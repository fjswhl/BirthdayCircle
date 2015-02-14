//
//  UserProfileService.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/10.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

private let sharedInstance = UserProfileService()

class UserProfileService {
    
    private init() {
    }
    
    class var sharedProfile: UserProfileService {
        return sharedInstance
    }
    
    var profile: User?
    
    
    /**
    获取个人信息，先从数据库取，没有的话从网络取
    
    :param: completion 可在此闭包里访问 profile
    */
    func fetchProfile(completion: (userProfile: User) -> Void) {
        
        let results = User.MR_findByAttribute("phone", withValue: NSUserDefaults.standardUserDefaults().objectForKey(USER_PHONE_KEY) as String)
        if results.count != 0 {
            self.profile = results[0] as? User
            completion(userProfile: self.profile!)
            return
        }
        
        
        let webSh = WebServicesHandler.sharedHandler
        
        webSh.fetchProfile { (data) -> Void in
            if let t = data["success"].null {
                println("请先登入")
            }
            
            self.profile = User.MR_createEntity()
            self.profile?.fillWithJSON(data["success"])

            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()

            completion(userProfile: self.profile!)
        }
    }
}
