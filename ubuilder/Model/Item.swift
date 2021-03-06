//
//  Item.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Project: IObject, Mappable {
    var name: String = ""
    var description: String = ""
    var type: ProjectType!
    var image: String = ""
    var code: String = ""
    var owner: History!
    var done: Bool = false
    var module: Module = Module()
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    override func toString() -> String {
        return self.name
    }
    func getTaskDoneCount() -> Int{
        let dones = self.module.tasks.filter { (task) -> Bool in
            return task.done == true
            }.count
        return dones
    }
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name     <- map["name"]
        self.type     <- map["type"]
        self.image   <- map["image"]
        self.description     <- map["description"]
        self.code     <- map["code"]
        self.done     <- map["done"]
        self.owner   <- map["owner"]
        self.module   <- map["module"]
    }
    func getImage() -> UIImage? {
        return Util.getImage(data64: self.image)
    }
    func getModuleCountStr() -> String {
        let dones = getTaskDoneCount()
        let hasS = self.module.tasks.count == 1 ? "" : "s"
        let str = "\(dones)/\(self.module.tasks.count) module\(hasS)"
        return str
    }
    func getTotalCost() -> Int {
        let total = self.module.tasks.reduce(0) { $0 + $1.price.toInt() }
        return total
    }
    func isDoneAllTasks() -> Bool {
        return self.module.tasks.count > 0 && self.module.tasks.count == self.getTaskDoneCount()
    }
}
class Item: IObject, Mappable {
    var name: String = ""
    var price: String = ""
    var description: String = ""
    var category: Category!
    var image: String = ""
    
    var code: String = ""
    var sellCode: String = ""
    var buyerCode: String = ""
    var bluetoothCode: String = ""
    var section: Section!
    var owner: History!
    var buyer: History?
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name     <- map["name"]
        self.price   <- map["price"]
        self.category     <- map["category"]
        self.image   <- map["image"]
        self.description     <- map["description"]

        self.code     <- map["code"]
        self.sellCode   <- map["sellCode"]
        self.buyerCode     <- map["buyerCode"]
        self.bluetoothCode   <- map["bluetoothCode"]
        self.section   <- map["section"]
        self.owner   <- map["owner"]
        self.buyer   <- map["buyer"]
    }
    func getImage() -> UIImage? {
        return Util.getImage(data64: self.image)
    }
    func getProductCode() -> String {
        var code = ""
        if self.buyerCode.count > 0 {
            code = self.buyerCode
        }
        else if self.sellCode.count > 0 {
            code = self.sellCode
        }
        else {
            code = self.code
        }
       return code
    }
    
}
class Section: Mappable {
    var code : String = ""
    var history: [History] = []
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.code <- map["code"]
        self.history <- map["history"]
    }
}
class Module: Mappable {
    
    var tasks: [Task] = []
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.tasks <- map["tasks"]
    }
}

class Task: IObject, Mappable {
    var code : String = ""
    var owner: User!
    var name: String = ""
    var price: String = ""
    var time: Int64 = Util.getCurrentMilitime()
    var material: Material = Material()
    var done: Bool = false
    override init() {
        self.time = Util.getCurrentMilitime()
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.code <- map["code"]
        self.price <- map["price"]
        self.owner <- map["owner"]
        self.material <- map["material"]
        self.done <- map["done"]
        self.time <- map["time"]
    }
}
class Material: Mappable {
    
    var items: [Item] = []
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.items <- map["items"]
    }
}
