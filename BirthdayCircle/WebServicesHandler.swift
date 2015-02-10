//
//  WebServicesHandler.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/9.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

private let sharedInstance = WebServicesHandler()

class WebServicesHandler: NSObject {
    private let baseURL = "http://dev.huihuixinxi.com:8080/birth"
    private let getAuthCodeURL = "/User/getCheckCodeForReg"
    

    class var sharedHandler: WebServicesHandler {
        return sharedInstance
    }
    
    func getAuthCode(#phone: String, handler: (status: Bool) -> Void) {
        let params = ["phone": phone]
        
        request(.POST, synthesizedURL(path: getAuthCodeURL), parameters: params)
            .response { (_, _, data, _) -> Void in
            let json = JSON(data!)
            if countElements(json["success"].stringValue) != 0 {
                handler(status: true)
            }
        }
    }
    

    /**
        以 baseURL 为 base 合成 URL
    
    :param: path 接口地址
    
    :returns: 合成后的 URL
    */
    func synthesizedURL(#path: String) -> String {
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let os_type = UIDevice.currentDevice().systemVersion
        let app_version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as String
        return "\(baseURL)\(getAuthCodeURL)?uuid=\(uuid)&app_ver=\(app_version)&os_type=\(os_type)"
    }
}
