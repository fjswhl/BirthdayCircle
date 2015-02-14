//
//  WebServicesHandler.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/9.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

private let sharedInstance = WebServicesHandler()
private let DEBUG = true

class WebServicesHandler: NSObject {
    private let baseURL = "http://dev.huihuixinxi.com:8080/birth"
    private let getAuthCodeURL = "/User/getCheckCodeForReg"
    private let signUpURL = "/User/register"
    private let signInURL = "/User/login"
    private let logoutURL = "/User/logout"
    private let updateProfileURL = "/User/updateProfile"
    private let updatePortraitURL = "/User/updatePortrait"
    private let fetchProfileURL = "/User/fetchProfile"
    private let getCheckCodeForResetURL = "/User/getCheckCodeForReset"
    private let resetPWDURL = "/User/resetPWD"
    private let modPWDURL = "/User/modPWD"
    private let getCheckCodeForChangePhoneURL = "/User/getCheckCodeForChangePhone"
    private let changePhoneURL = "/User/changePhone"

    // 用户联系人
    private let addFriend = "/Friend/addFriend"
    
    var userLogged: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_KEY)
        }
    }
    
    class var sharedHandler: WebServicesHandler {
        return sharedInstance
    }
    
    
    // MARK: 请求方法，对应服务器的每个接口
    func getAuthCode(#phone: String, handler: (data: JSON) -> Void) {
        let params = ["phone": phone]
        let url = synthesizedURL(path: getAuthCodeURL)
        
        requestDispatcher(params, url, handler)
    }
    
    func signup(#pwd: String, checkCode: String, phone: String, handler: (data: JSON) -> Void) {
        let md5ed = pwd.md5[0...19].md5
        let params = ["password": md5ed,
                      "checkcode": checkCode,
                      "phone": phone]
        let url = synthesizedURL(path: signUpURL)
        
        requestDispatcher(params, url, handler)
    }
    
    func signin(#phone: String, pwd: String, handler: (data: JSON) -> Void) {
        let md5ed = pwd.md5
        let params = ["phone": phone,
                      "password": md5ed]
        let url = synthesizedURL(path: signInURL)
        
        requestDispatcher(params, url, handler)
        
    }
    
    func autoLogin(handler: (data: JSON) -> Void) {
        if NSUserDefaults.standardUserDefaults().boolForKey(USER_DID_LOGIN_KEY) {
            
            let pwd = NSUserDefaults.standardUserDefaults().objectForKey(USER_PWD_KEY) as String
            let phone = NSUserDefaults.standardUserDefaults().objectForKey(USER_PHONE_KEY) as String
            
            println("---自动登入中---")
            signin(phone: phone, pwd: pwd, handler: handler)
        }
    }
    
    func logout(handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: logoutURL)
        requestDispatcher(nil, url, handler)
    }
    
    func updateProfile(#birthday: String?, birthplace: String?, username: String?, sex: String?, handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: updateProfileURL)
        var params: [String: String] = [String: String]()
        if let t = birthday{
            params["birthday"] = birthday
        }
        if let t = birthplace {
            params["birthplace"] = birthplace
        }
        if let t = username {
            params["username"] = username
        }
        if let t = sex {
            params["sex"] = sex
        }
        
        requestDispatcher(params, url, handler)
    }
    
    func updatePortrait(fileURL: NSURL, handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: updatePortraitURL)
        
        upload(.POST, url, fileURL)
    }
    
    func fetchProfile(handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: fetchProfileURL)
        
        requestDispatcher(nil, url, handler)
    }
    
    func getCheckCodeForReset(#phone: String, handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: getCheckCodeForResetURL)
        let params = ["phone": phone]
        
        requestDispatcher(params, url, handler)
    }
    
    func resetPWD(#pwd: String, checkcode: String, handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: resetPWDURL)
        let md5ed = pwd.md5[0...19].md5
        let params = ["password": md5ed,
                      "checkcode": checkcode]
        
        requestDispatcher(params, url, handler)
    }
    
    func modPWD(oldpassword: String, newpassword: String, handler: (data: JSON) -> Void){
        let url = synthesizedURL(path: modPWDURL)
        let params = ["oldpassword": oldpassword.md5,
                      "newpassword": newpassword.md5]
        
        requestDispatcher(params, url, handler)
    }
    
    func getCheckCodeForChangePhone(phone: String, handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: getCheckCodeForChangePhoneURL)
        let params = ["phone": phone]
        
        requestDispatcher(params, url, handler)
    }
    
    func changePhone(checkcode: String, handler: (data: JSON) -> Void) {
        let url = synthesizedURL(path: changePhoneURL)
        let params = ["checkcode": checkcode]
        
        requestDispatcher(params, url, handler)
    }
    
    
    // MARK: -

    /**
        以 baseURL 为 base 合成 URL
    
    :param: path 接口地址
    
    :returns: 合成后的 URL
    */
    func synthesizedURL(#path: String) -> String {
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let os_type = UIDevice.currentDevice().systemVersion
        let app_version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as String
        
        return "\(baseURL)\(path)?uuid=\(uuid)&app_ver=\(app_version)&os_type=iOS\(os_type)"
    }
    
    
    /**
    因为每个请求方法都要使用request，并在请求完成后把数据传回调用方，这样的代码在每个请求方法里都一样，因此
    提出来独立作为一个方法
    
    :param: params  请求参数
    :param: url     请求的 url
    :param: handler 处理结果的闭包
    */
    func requestDispatcher(params: [String: AnyObject]?, _ url: String, _ handler: (data: JSON) -> Void) {
        request(.POST, url, parameters: params)
            .responseJSON { (req, _, data, error) -> Void in
                let json = JSON(data!)
                self.debugInfo(url, params, json)
                
                if error != nil {
                    println("\(__FUNCTION__) errors: \(error)")
                }
                

                /// 如果用户已登入，但是 session 过期了，则自动重新登入
                if json["error"].stringValue == "loadfirst" || json["error"].stringValue == "loginfirst"{
                    self.autoLogin({ (data) -> Void in

                        if let uid = data["success"].int {
                            println("登入成功 uid：\(uid)")
                            self.requestDispatcher(params, url, handler)
                        } else {
                            println("帐号或密码不正确")
                        }
                    })


                    return
                }
                
                handler(data: json)
                

                
        }
        
    }
    
    func debugInfo(url: String, _ params: [String: AnyObject]? ,_ data: JSON) {
        if DEBUG {
            println("posted url: \(url)")
            println("params: \(params)")
            println("result: \(data)")
        }
    }
}














