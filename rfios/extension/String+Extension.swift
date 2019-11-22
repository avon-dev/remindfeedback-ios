//
//  String+Extension.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/22.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation

extension String {
    
    // 이메일 정규식 검사, @와.존재와 위치 체크
    public func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
    // 비밀번호 정규식 검사, 최소8자, 대문자, 소문자, 숫자
    public func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,16}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    
}
