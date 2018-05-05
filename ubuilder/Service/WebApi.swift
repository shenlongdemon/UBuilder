//
//  File.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

//
//  WebApi.swift
//  ugutaDID
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class WebApi{
    //static let HOST = "http://96.93.123.234:5000"
    static let HOST = "http://192.168.1.5:5000"
    //static let HOST = "http://192.168.79.84:5000"

    static let GET_CATEGORIES = "\(WebApi.HOST)/api/sellrecognizer/getCategories"

    static let GET_PRODUCT_BY_CATEGORY = "\(WebApi.HOST)/api/sellrecognizer/getProductsByCategory"
    static let GET_DESCRIPTION_BY_QRCODE = "\(WebApi.HOST)/api/sellrecognizer/getDescriptionQRCode"
    static let GET_ITEM_BY_QRCODE = "\(WebApi.HOST)/api/sellrecognizer/getItemByQRCode"
    static let LOGIN = "\(WebApi.HOST)/api/sellrecognizer/login"
    static let GET_ITEMS_BY_USERID = "\(WebApi.HOST)/api/sellrecognizer/getItemsByOwnerId"
    static let ADD_ITEM = "\(WebApi.HOST)/api/sellrecognizer/insertItem"
    static let PUBLISH_SELL = "\(WebApi.HOST)/api/sellrecognizer/publishSell"
    static let PAYMENT = "\(WebApi.HOST)/api/sellrecognizer/payment"
    static let UPDATE_USER = "\(WebApi.HOST)/api/sellrecognizer/updateUser"
    static let COMFIRM_RECEIVED = "\(WebApi.HOST)/api/sellrecognizer/confirmReceiveItem"
    static let GET_PRODUCTS_BY_BLUETOOTH_CODES = "\(WebApi.HOST)/api/sellrecognizer/getProductsByBluetoothCodes"
    static let CANCEL_SELL =  "\(WebApi.HOST)/api/sellrecognizer/cancelSell"
    
    static let GET_PROJECTS_BY_USERID = "\(WebApi.HOST)/api/ubuilder/getProjectsByOwnerId"
    static let ADD_PROJECT = "\(WebApi.HOST)/api/ubuilder/insertProject"
    static let GET_PROJECT_TYPES = "\(WebApi.HOST)/api/ubuilder/getProjectTypes"
    static let GET_USER_BY_ID = "\(WebApi.HOST)/api/ubuilder/getUserById"
    static let ADD_TASK = "\(WebApi.HOST)/api/ubuilder/addTask"
    static let GET_PROJECT_BY_ID = "\(WebApi.HOST)/api/ubuilder/getProjectById"
    static let GET_PROJECT_OR_TASK_BY_QRCODE = "\(WebApi.HOST)/api/ubuilder/getProjectOrTaskByQRCode"

    
    static func manager()-> SessionManager{
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 180
        return manager
    }
    static func getProjectsByOwnerId(userId: String, completion: @escaping (_ list:[Project])->Void){
        let url = URL(string: "\(WebApi.GET_PROJECTS_BY_USERID)?ownerId=\(userId)&pageNum=1&pageSize=10000")
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel : ApiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }                
                if(apiModel.Status == 1){
                    let items : [Project] = Mapper<Project>().mapArray(JSONObject: apiModel.Data) ?? []
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getWeather(lat: Double, lon: Double, completion: @escaping (_ weather:Weather)->Void){
        let str =   "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&APPID=6435508fad5982cda8c0a812d7a57860&units=metric"
        let url = URL(string: str)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                let dic = data.result.value as! NSDictionary
                let weather : Weather = dic.cast()!
//                let sys = dic.object(forKey: "sys") as! NSDictionary
//
//                let address = sys.object(forKey: "country") as! String
//                let main = dic.object(forKey: "main")  as! NSDictionary
//                let temp = main.object(forKey: "temp") as! Double
                completion(weather)
                
        }
    }
    static func addItem(item: Item, completion: @escaping (_ done: Bool )->Void){
        let json = item.toJSON()
        let url = URL(string: WebApi.ADD_ITEM)
        
        WebApi.manager().request(url!, method: .post, parameters: json, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(false)
                    return
                }
                
                if(apiModel.Status == 1){
                    completion(true)
                }
                else {
                    completion(false)
                }
                
                
        }
    }
    static func addProject(item: Project, completion: @escaping (_ project: Project? )->Void){
        let json = item.toJSON()
        let url = URL(string: WebApi.ADD_PROJECT)
        
        WebApi.manager().request(url!, method: .post, parameters: json, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel : ApiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let proj : Project? = Mapper<Project>().map(JSONObject: apiModel.Data)
                    completion(proj)
                }
                else {
                    completion(nil)
                }
                
                
        }
    }
    static func getProjectOrTaskByQRCode(code: String, completion: @escaping (_ project: Project?, _ task: Task?, _ isProjectNotTask: Bool )->Void){
        let parameters: Parameters = [
            "code": code
        ]
        let url = URL(string: WebApi.GET_PROJECT_OR_TASK_BY_QRCODE)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(nil, nil, false)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let isProjectNotTask: Bool = dic.object(forKey: "isProjectNotTask") as! Bool
                    if isProjectNotTask {
                        let project: Project? = Mapper<Project>().map(JSONObject: dic.object(forKey: "project"))
                        completion(project,nil, true)
                    }
                    else {
                        let task: Task? = Mapper<Task>().map(JSONObject: dic.object(forKey: "task"))
                        let project: Project? = Mapper<Project>().map(JSONObject: dic.object(forKey: "project"))
                        completion(project, task, false)
                    }
                    
                }
                else {
                    completion(nil, nil, false)
                }
                
        }
    }
    static func getDescriptionQRCode(code: String, completion: @escaping (_ description: String )->Void){
        let parameters: Parameters = [
            "code": code
            ]
        let url = URL(string: WebApi.GET_DESCRIPTION_BY_QRCODE)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion("Error")
                    return
                }
                
                if(apiModel.Status == 1){
                    let description = apiModel.Data as! String
                    
                    completion(description)
                }
                else {
                    completion("Error")
                }
                
        }
    }
    
    
    /*var userId = data.id;
     var user = data.user;*/
    
    static func updateUser(user: User, completion: @escaping (_ done: Bool )->Void){
        let parameters: Parameters = [
            "id": user.id,
            "user": user.toJSON()
        ]
        let url = URL(string: WebApi.UPDATE_USER)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(false)
                    return
                }
                
                if(apiModel.Status == 1){
                    
                    completion(true)
                }
                else {
                    completion(false)
                }
                
        }
    }
    static func addTask(projectId : String, task: Task, completion: @escaping (_ done: Bool )->Void){
        let parameters: Parameters = [
            "projectId": projectId,
            "task": task.toJSON()
        ]
        let url = URL(string: WebApi.ADD_TASK)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(false)
                    return
                }                
                if(apiModel.Status == 1){
                    
                    completion(true)
                }
                else {
                    completion(false)
                }
                
        }
    }
    
    static func payment(itemId: String, userInfo: History, completion: @escaping (_ item: Item? )->Void){
        let parameters: Parameters = [
            "itemId": itemId,
            "buyerInfo": userInfo.toJSON()
        ]
        let url = URL(string: WebApi.PAYMENT)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let item : Item = dic.cast()!
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    static func publishSell(itemId: String, ownerInfo: History, completion: @escaping (_ item: Item? )->Void){
        let parameters: Parameters = [
            "itemId": itemId,
            "userInfo": ownerInfo.toJSON()
        ]
        let url = URL(string: WebApi.PUBLISH_SELL)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                     let dic = apiModel.Data as! NSDictionary
                    let item : Item = dic.cast()!
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    
    static func cancelSell(itemId: String,completion: @escaping (_ done: Bool )->Void){
        
        let url = URL(string: "\(WebApi.CANCEL_SELL)?id=\(itemId)")
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(false)
                    return
                }
                
                if(apiModel.Status == 1){
                    completion(true)
                }
                else {
                    completion(false)
                }
                
        }
    }
    static func confirmReceived(itemId: String,completion: @escaping (_ done: Bool )->Void){
        
        let url = URL(string: "\(WebApi.COMFIRM_RECEIVED)?id=\(itemId)")
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(false)
                    return
                }
                
                if(apiModel.Status == 1){
                    completion(true)
                }
                else {
                    completion(false)
                }
                
        }
    }
    static func getUserById(userId: String,completion: @escaping (_ user: User? )->Void){
        
        let url = URL(string: "\(WebApi.GET_USER_BY_ID)?userid=\(userId)")
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let user : User? = Mapper<User>().map(JSONObject: apiModel.Data)
                    completion(user)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    static func login(phone: String, password: String,completion: @escaping (_ user: User? )->Void){
       
        let url = URL(string: "\(WebApi.LOGIN)?phone=\(phone.replacingOccurrences(of: "+", with: "%2B"))&password=\(password)")
      
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let user : User = dic.cast()!
                    completion(user)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    static func getItemByQRCode(code: String, completion: @escaping (_ item: Item? )->Void){
        let parameters: Parameters = [
            "code": code
        ]
        let url = URL(string: WebApi.GET_ITEM_BY_QRCODE)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let i : Item = dic.cast()!
                    completion(i)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    
    static func getCategories(completion: @escaping (_ list:[Category])->Void){
        
        let url = URL(string: WebApi.GET_CATEGORIES)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let arr = apiModel.Data as! [Any]
                    var categories : [Category] = []
                    for jsonItem in arr{
                        let strJSON = jsonItem as! NSDictionary
                        let category : Category = strJSON.cast()!
                        categories.append(category)
                    }
                    completion(categories)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getProjectTypes(completion: @escaping (_ list:[ProjectType])->Void){
        
        let url = URL(string: WebApi.GET_PROJECT_TYPES)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    
                    var projectTypes : [ProjectType] = Mapper<ProjectType>().mapArray(JSONObject: apiModel.Data) ?? []
                    completion(projectTypes)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getProductsByBluetoothCodes(codes: [String], completion: @escaping (_ list:[Item])->Void){
        
        let url = URL(string: WebApi.GET_PRODUCTS_BY_BLUETOOTH_CODES)
        let parameters: Parameters = [
            "names": codes
        ]
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let items : [Item] = Mapper<Item>().mapArray(JSONObject:apiModel.Data)!                   
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    
    static func getProductsByCategory(categoryId: String, completion: @escaping (_ list:[Item])->Void){
        let url = URL(string: "\(WebApi.GET_PRODUCT_BY_CATEGORY)?categoryId=\(categoryId)&pageNum=1&pageSize=10000")
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let arr = apiModel.Data as! [Any]
                    var items : [Item] = []
                    for jsonItem in arr{
                        let strJSON = jsonItem as! NSDictionary
                        let item : Item = strJSON.cast()!
                        items.append(item)
                    }
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getItemsByOwnerId(userId: String, completion: @escaping (_ list:[Item])->Void){
        let url = URL(string: "\(WebApi.GET_ITEMS_BY_USERID)?ownerId=\(userId)&pageNum=1&pageSize=10000")
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) as? ApiModel else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let arr = apiModel.Data as! [Any]
                    var items : [Item] = []
                    for jsonItem in arr{
                        let strJSON = jsonItem as! NSDictionary
                        let item : Item = strJSON.cast()!
                        items.append(item)
                    }
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func getProjectById(id: String, completion: @escaping (_ project: Project?)->Void){
        let url = URL(string: "\(WebApi.GET_PROJECT_BY_ID)?id=\(id)")
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let item : Project? = Mapper<Project>().map(JSONObject: apiModel.Data)
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    
}

