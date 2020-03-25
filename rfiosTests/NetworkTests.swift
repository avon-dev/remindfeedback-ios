//
//  NetworkTests.swift
//  rfiosTests
//
//  Created by Taeheon Woo on 2020/03/11.
//  Copyright © 2020 avon. All rights reserved.
//

import Foundation
import XCTest 

class NetworkTests: XCTestCase {
    
    var cookie: HTTPCookie?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cookie = UserDefaultsHelper.sharedInstantce.getCookie()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        print("cookie", cookie)
        APIHelper.sharedInstance.pushRequest(.findFriend(["email":"test1@naver.com"]))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
