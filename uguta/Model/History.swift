//
//  History.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class History: User {
    var code: String = ""
    var position: Position!
    var weather: Weather!
    var time: Int64 = 0
    var index:Int = 0
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.code     <- map["code"]
        self.time     <- map["time"]
        self.position   <- map["position"]
        self.weather     <- map["weather"]
    }
}
class Weather: Mappable {
    var main: WeatherMain!
    var sys: WeatherSys!
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.main     <- map["main"]
        self.sys     <- map["sys"]
    }
}
class WeatherMain: Mappable {
    var temp: Double = 0
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.temp     <- map["temp"]
    }
}
class WeatherSys: Mappable {
    var country: String = ""
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.country     <- map["country"]
    }
}
class Position: Mappable {
    var coords: Coord!
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.coords     <- map["coords"]
    }
}
class Coord: Mappable {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var altitude: Double = 0.0
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.latitude   <- map["latitude"]
        self.longitude   <- map["longitude"]
        self.altitude   <- map["altitude"]
    }
}
