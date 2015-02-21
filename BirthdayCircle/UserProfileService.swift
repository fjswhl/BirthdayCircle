//
//  UserProfileService.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/10.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

private let sharedInstance = UserProfileService()

class UserProfileService: NSObject {
    
    typealias handleProfile = (userProfile: User?) -> Void
    
    private override init() {

    }
    
    class var sharedProfile: UserProfileService {
        return sharedInstance
    }

    
    var profile: User?
    
    
    /**
    获取个人信息，先从数据库取，没有的话从网络取
    
    :param: completion 可在此闭包里访问 profile
    */
    
    
    func loadProfileFromRemote(completion: handleProfile?) {
        let webSh = WebServicesHandler.sharedHandler
        
        webSh.fetchProfile { (data) -> Void in
            if let t = data["success"].null {
                println("请先登入")
            }
            
            if self.profile == nil {
                self.profile = User.MR_createEntity()
            }
            self.profile?.fillWithJSON(data["success"])
            
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            
            completion?(userProfile: self.profile!)
        }
    }
    
    func loadProfileFormCoreData() -> Bool {
        let results = User.MR_findByAttribute("phone", withValue: NSUserDefaults.standardUserDefaults().objectForKey(USER_PHONE_KEY) as String)
        if results.count != 0 {
            self.profile = results[0] as? User
            return true
        }
        return false
    }
    
    func fetchProfile(completion: handleProfile) {
        
        let results = User.MR_findByAttribute("phone", withValue: NSUserDefaults.standardUserDefaults().objectForKey(USER_PHONE_KEY) as String)
        if results.count != 0 {
            self.profile = results[0] as? User
            completion(userProfile: self.profile!)
            return
        }
        
        
        loadProfileFromRemote { (userProfile) -> Void in
            completion(userProfile: userProfile)
        }
    }
    
}
