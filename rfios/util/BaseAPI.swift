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
    case getCategory(_ id: String)
    case addCategory(_ params: [String:Any?]?)
    case modCategory(_ params: [String:Any?]?, id: String)
    case delCategory(_ id: String)
    
    // Feedback
    case getFeedbacks(lastId: String)
    case getMyFeedbacks(lastId: String)
    case getYourFeedbacks(lastId: String)
    case addFeedback(_ params: [String:Any?]?)
    case modFeedback(_ params: [String:Any?]?, id: String)
    case delFeedback(_ id: String)
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
        case .getCategory(let id):
            return "/category/selectone/\(id)"
        case .addCategory:
            return "/category/create"
        case .modCategory(_, let id):
            return "/category/update/\(id)"
        case .delCategory(let id):
            return "/category/delete/\(id)"
        
        case .getFeedbacks(let lastId):
            return "/feedback/all/\(lastId)"
        case .getMyFeedbacks(let lastId):
            return "/feedback/my/\(lastId)"
        case .getYourFeedbacks(let lastId):
            return "/feedback/your/\(lastId)"
        case .addFeedback:
            return "/feedback/create"
        case .modFeedback(_, let id):
            return "/feedback/update/\(id)"
        case .delFeedback(let id):
            return "/feedback/\(id)"
        
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .register, .login, .addCategory, .addFeedback:
            return .post
        case .me, .getCategories, .getCategory, .getFeedbacks, .getMyFeedbacks, .getYourFeedbacks:
            return .get
        case .delCategory, .delFeedback:
            return .delete
        case  .modCategory, .modFeedback:
            return .put
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
        
        // category
        case .me:
            return .requestPlain
        case .getCategories:
            return .requestPlain
        case .getCategory(let id):
            return .requestPlain
        case .addCategory(let params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        case .modCategory(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        case .delCategory(let id):
            return .requestPlain
            
        // feedback
        case .getFeedbacks(let lastId):
            return .requestPlain
        case .getMyFeedbacks(let lastId):
            return .requestPlain
        case .getYourFeedbacks(let lastId):
            return .requestPlain
        case .addFeedback(let params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        case .modFeedback(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        case .delFeedback(let id):
            return .requestPlain
            
        }
        
        
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
