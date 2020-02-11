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
import SwiftyJSON

struct APIResult {
    
    var isSuccess = false
    var statusCode: Int
    var msg: String?
    var data: [String:Any]?
    var dataDic: [[String:Any]]?
        
    init(_ statusCode: Int, msg: String? = nil, data: [String:Any]? = nil, dataDic: [[String:Any]]? = nil) {
        
        if statusCode == 200 || statusCode == 201 {
            self.isSuccess = true
        }
        
        self.statusCode = statusCode
        self.msg = msg
        self.data = data
        self.dataDic = dataDic
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
            .map {
                return APIResult($0.statusCode)
            }
    }
    
    func rxPullResponse(_ task: BaseAPI) -> Observable<APIResult> {
        
        return provider.rx.request(task)
        .asObservable()
        .map {
            NWLog.sLog(contentName: "response", contents: $0)
            var dic: [String: Any]? = [:]
            
            do {
                dic = try $0.mapJSON() as? [String: Any]
                print("dictionary", dic)
                
                
            } catch {
                print("mapJSON 실패")
                dic = nil
            }
            
            print("dic data", dic?["data"] as? [String:Any])
            print("json", JSON(dic?["data"]))
            
            return APIResult($0.statusCode, msg: dic?["message"] as? String, data: dic?["data"] as? [String:Any], dataDic: dic?["data"] as? [[String:Any]] )
            
        }
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
//            .map { return APIResult($0.statusCode, data: try $0.mapString()) }
            .map { return APIResult($0.statusCode) }
    }
    
    func pushRequest(_ task: BaseAPI) {
        
        provider.request(task) { result in
            
            print("요청 url", result.value?.request?.url)
            print("요청 method", result.value?.request?.httpMethod)
            print("요청 body", NSString(data: (result.value?.request?.httpBody)!, encoding:  String.Encoding.utf8.rawValue))
            
            switch result {
            case let .success(moyaResponse):
//                let header = moyaResponse.response?.allHeaderFields
//                let data = moyaResponse.data
//                let statusCode = moyaResponse.statusCode
                
                switch moyaResponse.statusCode {
                    
                case 200...201:
                    do {
                        print(try moyaResponse.mapJSON())
                    } catch {
                        
                    }
                    
                default:
                    print("응답 실패")
                    do {
                        print(try moyaResponse.statusCode)
                        print(try String(data: moyaResponse.data, encoding: String.Encoding.utf8))
                    } catch {
                        
                    }
                    
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
