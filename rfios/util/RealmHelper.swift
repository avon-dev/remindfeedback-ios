//
//  RealmHelper.swift
//  rfios
//
//  Created by Taeheon Woo on 2020/01/20.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum RealmDBError: Error {
    case indexOutOfBoundsException // 조회하려는 대상의 인덱스 범위를 벗어날때 발생시키는 에러
}

/// 렘에 write할 때, 트랜잭션이 완료되는 것을 파악하기 위해서 익스텐션 지정
///
extension Realm {
    func write(transaction block: () -> Void, completion: () -> Void) throws {
        try write(block)
        completion()
    }
}

class RealmHelper {
    /// 자체적으로 내부에서 사용할 Realm변수
    private var realm: Realm
    
    /// 포피스 앱 전체에서 Realm객체를 싱글톤으로 관리하기 위해 사용
    static let sharedInstantce = RealmHelper()
    
    /// RealmDB 초기화 및 선언
    private init() {
        realm = try! Realm()
    }
    
    func insert(_ obj: Object) {
        // 로컬에 저장시도
        try! realm.write(
            // 로컬에 insert
            transaction: {
                realm.add(obj)
        },
            // 트랜잭션이 완료되었을 때, 호출
            completion: {
                NWLog.sLog(contentName: "realm에 add 성공", contents: nil)
        })
    }
    
    func deleteObjs<Element: Object>(_ type: Element.Type) {
        
        let objs = self.getRawResults(type)
        
        try! realm.write(
            transaction: {
                realm.delete(objs)
        },
            completion: {
                NWLog.sLog(contentName: "realm에 \(type) 전체 delete 성공", contents: nil)
        })
    }
    
    func getRawResults<Element: Object>(_ type: Element.Type) -> Results<Element> {
        return realm.objects(type)
    }
    
    func getResults<Element: Object>(_ type: Element.Type, filterTxt: String) -> Results<Element> {
        return self.getRawResults(type).filter(filterTxt)
    }
    
    func getResults<Element: Object>(_ type: Element.Type, sortKeyPath: String, ascending: Bool) -> Results<Element> {
        return self.getRawResults(type).sorted(byKeyPath: sortKeyPath, ascending: ascending)
    }
    
    //
    
    func overwrite<Element: Object>(_ type: Element.Type, objs: [Element]) {
        
        NWLog.dLog(contentName: "테스트", contents: objs)
        
        let objs = self.getRawResults(type)
        
        try! realm.write(
            transaction: {
                realm.delete(objs)
        },
            completion: {
                NWLog.sLog(contentName: "realm에 \(type) 전체 delete 성공", contents: nil)
                
                try! realm.write(
                    transaction: {
                        realm.add(objs.first!)
                },
                    completion: {
                        NWLog.sLog(contentName: "realm에 \(type) overwrite 성공", contents: nil)
                })
        })
        
    }
    
}
