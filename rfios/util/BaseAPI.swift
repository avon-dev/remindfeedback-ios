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
    
    // MyPage
    case getMyPage
    case modNickName(_ params: [String:String])
    case modIntro(_ params: [String:String])
    case modPortrait(image: UIImage)
    
    // Friend
    case getFriends
    case findFriend(_ params: [String:String])
    case addFriend(_ params: [String:Any?]?)
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: RemindFeedback.baseURL)! // 반드시 URL형태가 되기 때문에
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
            
            // MyPage
        case .getMyPage:
            return "/mypage"
        case .modNickName:
            return "/mypage/nickname"
        case .modIntro:
            return "/mypage/introduction"
        case .modPortrait:
            return "/mypage/portrait"
            
            // Friend
        case .getFriends, .addFriend:
            return "/friends"
        case .findFriend:
            return "/friends/search"
        
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .register, .login, .email, .addCategory,
             .addFeedback, .addTextCard, .addFriend, .findFriend:
            return .post
        case .me, .logout, .getCategories, .getCategory,
             .getFeedbacks, .getMyFeedbacks, .getYourFeedbacks,
             .getCards, .getMyPage, .getFriends:
            return .get
        case .unregister, .delCategory, .delFeedback, .delCard:
            return .delete
        case  .modCategory, .modFeedback, .modTextCard:
            return .put
        case .modNickName, .modIntro, .modPortrait:
            return .patch
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
        case .getCategories, .getCategory, .delCategory:
            return .requestPlain
        case .addCategory(let params), .modCategory(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        // feedback
        case .getFeedbacks, .getMyFeedbacks, .getYourFeedbacks, .delFeedback:
            return .requestPlain
        case .addFeedback(let params), .modFeedback(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        // card
        case .getCards, .delCard:
            return .requestPlain
        case .addTextCard(let params), .modTextCard(let params, _):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        
        // mypage
        case .getMyPage:
            return .requestPlain
        case .modNickName(let params), .modIntro(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .modPortrait(let image):
            let imageData = image.jpegData(compressionQuality: 1.0)
            let formData = MultipartFormData(provider: .data(imageData!), name: "portrait", fileName: "file.jpg", mimeType: "image/jpeg")
            let updatefile = MultipartFormData(provider: .data("true".data(using: .utf8)!), name: "updatefile")
            return .uploadMultipart([formData, updatefile])
            
        // friend
        case .getFriends:
            return .requestPlain
        case .addFriend(let params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        case .findFriend(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        }
        
        
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
