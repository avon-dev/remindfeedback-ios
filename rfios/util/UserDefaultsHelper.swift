//
//  userDefaultHelper.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/28.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDefaultsHelper {
    
    private var userDefaults: UserDefaults
    
    static let sharedInstantce = UserDefaultsHelper()
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.avon")!
    }
    
    /// 쿠키 저장 함수
    func setCookie(_ cookie: HTTPCookie) {
        NWLog.sLog(contentName: "set 쿠키", contents: cookie)
        
        userDefaults.setValue(cookie.properties as AnyObject?, forKey: "cookie")
        userDefaults.synchronize()
    }
    
    /// 저장된 쿠키 불러오는 함수
    func getCookie() -> HTTPCookie? {
        
        guard let cookieObj = userDefaults.object(forKey: "cookie") else { return nil }
                
        guard let cookie = HTTPCookie(properties: cookieObj as! [HTTPCookiePropertyKey : Any]) else { return nil }
        
        return cookie
    }
    
    /// 쿠키 삭제함수
    func delCookie() {
        userDefaults.removeObject(forKey: "cookie")
    }
    
    /// uuid 저장함수
    func setUUID(_ uuid: String) {
        userDefaults.setValue("uuid", forKey: uuid)
    }
    
    /// uuid 호출함수
    func getUUID() -> String {
        guard let uuid = userDefaults.string(forKey: "uuid") else { return "" }
        return uuid
    }
    
    /// uuid 삭제함수
    func delUUID() {
        userDefaults.removeObject(forKey: "uuid")
    }
    
}
