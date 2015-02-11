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
    
    var profile: UserProfile?
    
    
    /**
    请求获取用户信息
    
    :param: completion 可在此闭包里访问 profile
    */
    func fetchProfile(completion: (userProfile: UserProfile) -> Void) {
        let webSh = WebServicesHandler.sharedHandler
        
        webSh.fetchProfile { (data) -> Void in
            if let t = data["success"].null {
                println("请先登入")
            }
            
            self.profile = UserProfile(json: data["success"])
            completion(userProfile: self.profile!)
        }
    }
}
