//
//  Preferences.swift
//  debugdrawer
//
//  Created by Elias Bagley on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import Foundation

class Preferences {
    class func save(_ key: String, object: AnyObject?) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }

    class func load(_ key: String) -> AnyObject? {
        return UserDefaults.standard.value(forKey: key) as AnyObject?
    }

    class func loadString(_ key: String) -> String {
        return (UserDefaults.standard.value(forKey: key) as? String) ?? ""
    }

    class func isSet(_ key: String) -> Bool {
        let object: AnyObject? = Preferences.load(key)
        return object != nil ? true : false
    }
}
