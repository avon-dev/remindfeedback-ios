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
        
    init(_ statusCode: Int, msg: String? = nil) {
        
        if statusCode == 201 {
            self.isSuccess = true
        }
        
        self.statusCode = statusCode
        self.msg = msg
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
            .map {  return APIResult($0.statusCode)  }
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
    
}
