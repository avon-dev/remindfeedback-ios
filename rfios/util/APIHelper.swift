//
//  APIHelper.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/28.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct APIResult {
    
    var isSuccess = false
    var statusCode: Int
    var msg: String?
    var data: String?
        
    init(_ statusCode: Int, msg: String? = nil, data: String? = nil) {
        
        if statusCode == 201 {
            self.isSuccess = true
        }
        
        self.statusCode = statusCode
        self.msg = msg
        self.data = data
    }
}

class APIHelper {
    
    static let sharedInstance = APIHelper()
    
    let provider: MoyaProvider<BaseAPI>
    
    private init() {
        provider = MoyaProvider<BaseAPI>()
    }
    
    func rxPushRequest(_ task: BaseAPI) -> Observable<APIResult> {
        return provider.rx.request(task)
            .asObservable()
            .map {  return APIResult($0.statusCode, data: try $0.mapString())  }
    }
    
    func rxSetSession(_ task: BaseAPI) -> Observable<APIResult> {
        return provider.rx.request(task)
            .asObservable()
            .do(onNext: {
                if let headerFields = $0.response?.allHeaderFields as? [String: String], let URL = $0.request?.url {
                    
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                    print("쿠키", cookies)
                    
                    if let connectSid = cookies.first {
                        HTTPCookieStorage.shared.setCookie(connectSid)
                        UserDefaultsHelper.sharedInstantce.setCookie(connectSid)
                    }
                }
            })
            .map { return APIResult($0.statusCode, data: try $0.mapString()) }
    }
    
    func pushRequest(_ task: BaseAPI) {
        
        provider.request(task) { result in
            
//            print("body", NSString(data: (result.value?.request?.httpBody)!, encoding:  String.Encoding.utf8.rawValue))
            
            switch result {
            case let .success(moyaResponse):
//                let header = moyaResponse.response?.allHeaderFields
//                let data = moyaResponse.data
//                let statusCode = moyaResponse.statusCode
                
                switch moyaResponse.statusCode {
                    
                case 201:
                    do {
                        print(try moyaResponse.mapJSON())
                    } catch {
                        
                    }
                    
                default:
                    print("응답 실패")
                    
                }

            case let .failure(error):
                print("서버 통신 실패", error)
            }
            
//            return false
            
        } // END : provider.request
        
        
        
        
    } // END : func pushRequest(_ task:)
    
    func setSession(_ task: BaseAPI) {
        provider.request(task) { result in

//            print("body", NSString(data: (result.value?.request?.httpBody)!, encoding:  String.Encoding.utf8.rawValue))

            switch result {
            case let .success(moyaResponse):
                let header = moyaResponse.response?.allHeaderFields
                let cookie = header?["Set-Cookie"] as! String
                let connectSid = String(cookie.split(separator: ";")[0].split(separator: "=")[1])
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode

                if let headerFields = moyaResponse.response?.allHeaderFields as? [String: String], let URL = moyaResponse.request?.url
                {
                     let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                    HTTPCookieStorage.shared.setCookie(cookies.first!)
                     print("mCookie", cookies)
                }

                do {
                  // 4
                  print(try moyaResponse.mapJSON())
                } catch {

                }

                print("moyaResponse", moyaResponse)
                print("header", header)
                print("cookie", cookie)
                print("connect.sid", connectSid)
                print("data", data)
                print("status",statusCode)

            case let .failure(error):
                print("error",error)
            }
        }
    }
    
}
