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
    // Auth
    case register(_ params: [String:Any?]?)
    case login(_ params: [String:Any?]?)
    case me
    
    // Category
    case getCategories
    case addCategory(_ params: [String:Any?]?)
    case modCategory(_ params: [String:Any?]?, id: String)
    case delCategory(_ id: String)
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
        case .getCategories:
            return "/category/selectall"
        case .addCategory:
            return "/category/insert"
        case .modCategory(_, let id):
            return "/category/update/\(id)"
        case .delCategory(let id):
            return "/category/deleteone/\(id)"
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .register, .login, .addCategory:
            return .post
        case .me, .getCategories:
            return .get
        case .modCategory:
            return .put
        case .delCategory:
            return .delete
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
         
        case .getCategories:
            return .requestPlain
            
        case .addCategory(let params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        case .modCategory(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        case .delCategory(let id):
            return .requestPlain
        }
        
        
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
