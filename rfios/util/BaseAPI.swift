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
    case logout
    case unregister
    
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
    
    // Card
    case addTextCard(_ params: [String:Any?]?)
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://api.remindfeedback.com")! // 반드시 URL형태가 되기 때문에
    }
    
    var path: String {
        
        switch self {
        case .register:
            return "/auth/register"
        case .login:
            return "/auth/login"
        case .me:
            return "/auth/me"
        case .logout:
            return "/auth/logout"
        case .unregister:
            return "/auth/unregister"
            
            // category
        case .getCategories, .addCategory:
            return "/categories"
        case .getCategory(let id), .modCategory(_, let id), .delCategory(let id):
            return "/categories/\(id)"
        
            // feedback
        case .getFeedbacks(let lastId):
            return "/feedbacks/\(lastId)/20"
        case .getMyFeedbacks(let lastId):
            return "/feedbacks/mine/\(lastId)/10"
        case .getYourFeedbacks(let lastId):
            return "/feedbacks/yours/\(lastId)/10"
        case .addFeedback:
            return "/feedbacks"
        case .modFeedback(_, let id), .delFeedback(let id):
            return "/feedbacks/\(id)"
            
            // card
        case .addTextCard:
            return "/board/cards/text"
        
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .register, .login, .addCategory, .addFeedback, .addTextCard:
            return .post
        case .me, .logout, .getCategories, .getCategory, .getFeedbacks, .getMyFeedbacks, .getYourFeedbacks:
            return .get
        case .unregister, .delCategory, .delFeedback:
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
        // auth
        case .register(let params), .login(let params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default) // ??
        case .me, .logout, .unregister:
            return .requestPlain
        
        // category
        case .getCategories, .getCategory(_), .delCategory(_):
            return .requestPlain
        case .addCategory(let params), .modCategory(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        // feedback
        case .getFeedbacks(_), .getMyFeedbacks(_), .getYourFeedbacks(_), .delFeedback(_):
            return .requestPlain
        case .addFeedback(let params), .modFeedback(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        // card
        case .addTextCard(let params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        }
        
        
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
