//
//  BaseAPI.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/26.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum BaseAPI {
    case register(_ params: [String:Any?]?)
    case login(_ params: [String:Any?]?)
    case me
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://54.180.118.35")! // 반드시 URL형태가 되기 때문에
    }
    
    var path: String {
        
        switch self {
        case .register:
            return "/auth/signup"
        case .login:
            return "/auth/login"
        case .me:
            return "/auth/me"
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .register:
            return .post
        case .login:
            return .post
        case .me:
            return .get
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        
        switch self {
        case .register(let params):

            return .requestParameters(parameters: params!, encoding: JSONEncoding.default) // ??
            
        case .login(let params):
//            return .requestPlain
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default) // ??
            
        case .me:
            return .requestPlain
        }
        
        
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
