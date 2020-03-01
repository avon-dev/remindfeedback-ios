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
    case email(_ params: [String:Any?]?)
    
    // Category
    case getCategories
    case getCategory(_ id: String)
    case addCategory(_ params: [String:Any?]?)
    case modCategory(_ params: [String:Any?]?, id: String)
    case delCategory(_ id: String)
    
    // Feedback
    case getFeedbacks(lastID: String)
    case getMyFeedbacks(lastID: String)
    case getYourFeedbacks(lastID: String)
    case addFeedback(_ params: [String:Any?]?)
    case modFeedback(_ params: [String:Any?]?, id: String)
    case delFeedback(_ id: String)
    
    // Card
    case getCards(_ feedbackID: Int, _ lastID: Int)
    case addTextCard(_ params: [String:Any?]?)
    case modTextCard(_ params: [String:Any?]?, id: String)
    case delCard(_ id: String)
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.remindfeedback.com")! // 반드시 URL형태가 되기 때문에
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
        case .email:
            return "/auth/email"
            
            // category
        case .getCategories, .addCategory:
            return "/categories"
        case .getCategory(let id), .modCategory(_, let id), .delCategory(let id):
            return "/categories/\(id)"
        
            // feedback
        case .getFeedbacks(let lastID):
            return "/feedbacks/\(lastID)/20"
        case .getMyFeedbacks(let lastID):
            return "/feedbacks/mine/\(lastID)/10"
        case .getYourFeedbacks(let lastID):
            return "/feedbacks/yours/\(lastID)/10"
        case .addFeedback:
            return "/feedbacks"
        case .modFeedback(_, let id), .delFeedback(let id):
            return "/feedbacks/\(id)"
            
            // card
        case .getCards(let feedbackID, let lastID):
            return "/board/cards/\(feedbackID)/\(lastID)/20"
        case .addTextCard:
            return "/board/cards/text"
        case .modTextCard(_, let id):
            return "/board/cards/text/\(id)"
        case .delCard(let id):
            return "/board/cards/\(id)"
        
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .register, .login, .email, .addCategory, .addFeedback, .addTextCard:
            return .post
        case .me, .logout, .getCategories, .getCategory, .getFeedbacks, .getMyFeedbacks, .getYourFeedbacks, .getCards:
            return .get
        case .unregister, .delCategory, .delFeedback, .delCard:
            return .delete
        case  .modCategory, .modFeedback, .modTextCard:
            return .put
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        
        switch self {
        // auth
        case .register(let params), .login(let params), .email(let params):
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
        case .getCards, .delCard:
            return .requestPlain
        case .addTextCard(let params), .modTextCard(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        }
        
        
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
