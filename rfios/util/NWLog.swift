//
//  NWLog.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/12/01.
//  Copyright © 2019 avon. All rights reserved.
//

import Foundation

class NWLog {
    class func cLog(_ filename: String = #file, _ line: Int = #line, _ funcname: String = #function) {
        
        let file = URL(string: filename)?.lastPathComponent.components(separatedBy: ".").first ?? ""

        print("RF LOG(CHECK) \(file)(\(line)) \(funcname) ", terminator: "")

        print()
        
    }
    
    class func sLog(_ filename: String = #file, _ line: Int = #line, _ funcname: String = #function, contentName: String, contents: Any?) {
        
        let file = URL(string: filename)?.lastPathComponent.components(separatedBy: ".").first ?? ""
        
        print("RF LOG(SPECIAL) \(file)(\(line)) \(funcname) ", terminator: "")
        print("\(contentName) : \(String(describing: contents))")
        print()
        
    }
    
    class func dLog(_ filename: String = #file, _ line: Int = #line, _ funcname: String = #function, contentName: String, contents: Any?) {
        
        let file = URL(string: filename)?.lastPathComponent.components(separatedBy: ".").first ?? ""
        
        print("RF LOG(DEBUG) \(file)(\(line)) \(funcname) ", terminator: "")
        print("\(contentName)")
        print()
        debugPrint(contents as Any)
        
    }
}
