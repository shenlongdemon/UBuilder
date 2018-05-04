//
//  Store.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

//
//  Util.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import UIKit
import QRCode
import DataCompression
import Alamofire
import ObjectMapper
class Store {
   
    static func saveUser(user: User){
        let JSONString = user.toJSONString(prettyPrint: true)
        UserDefaults.standard.set(JSONString, forKey: "user")
    }
    static func savePosition(position: Position){
        let JSONString = position.toJSONString(prettyPrint: true)
        UserDefaults.standard.set(JSONString, forKey: "position")
    }
    
    static func getUser() -> User? {
        var user: User? = nil
        guard let json = UserDefaults.standard.object(forKey: "user") as? String else {
            return nil
        }
        user = json.cast()
        return user
    }
    static func getUserHistory() -> History? {
        var user: History? = nil
        guard let json = UserDefaults.standard.object(forKey: "user") as? String else {
            return nil
        }
        user = json.cast()
        return user
    }
    static func getPosition() -> Position? {
        var position: Position? = nil
        guard let json = UserDefaults.standard.object(forKey: "position") as? String else {
            return nil
        }
        position = json.cast()
        return position
    }
    
}

