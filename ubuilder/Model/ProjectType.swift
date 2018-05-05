//
//  ProjectType.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/5/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ProjectType: IObject, Mappable {
    var value: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {        
        self.value     <- map["value"]
        self.id <- map["id"]
    }
    
}
