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
class Util {
    static func getImage(data64: String) -> UIImage? {
        var uiimage:UIImage? = nil
        if (data64 != ""){
            let dataDecoded : Data = Data(base64Encoded: data64, options: .ignoreUnknownCharacters)!
            uiimage = UIImage(data: dataDecoded)
        }
        return uiimage
    }
    static func getQRCodeImage(str: String) -> UIImage?{
        var image : UIImage? = nil
        do{
            let qrCode = QRCode(str)
            image = qrCode?.image
        }
        catch _{
        
        }
        return image
    }
    static func showYesNoAlert(VC:UIViewController,  message:String?, yesHandle: @escaping (_ action:Void)->Void, noHandle: @escaping (_ action:Void)->Void){
        
            let alert = UIAlertController(title: "uGuta", message: message ?? "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in
                yesHandle(())
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(alert: UIAlertAction!) in
                
            }))
            VC.present(alert, animated: true, completion: nil)
        
    }
    static func showOKAlert(VC:UIViewController,  message:String?)-> Void {
        let alert = UIAlertController(title: "uGuta", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        VC.present(alert, animated: true, completion: nil)
    }
    static func resizeImage(image : UIImage) -> UIImage{
       
        let newSize: CGSize = CGSize(width: 70, height: 70)
       
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: 70, height: 70)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    static func getData64(image: UIImage?) -> String{
        guard let img = image else {
            return ""
        }
        let imageData:NSData = UIImagePNGRepresentation(img)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    static func getUesrInfo(completion: @escaping (_ history: History )->Void){
        var history : History = Store.getUserHistory()!
        history.position = Store.getPosition()!
        WebApi.getWeather(lat: history.position.coords.latitude, lon: history.position.coords.longitude) { (weather) in
            history.weather = weather
            let nowDoublevaluseis = NSDate().timeIntervalSince1970
            history.time = Int64(nowDoublevaluseis*1000)
            completion(history)
        }
    }

    static func drawOMIDCode(str : String) -> UIImage{
        let size = 500
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        
        // draw circle outside
        ctx.setLineWidth(5.0)
        ctx.setStrokeColor(UIColor.blue.cgColor)
        let circleOutsideRect = CGRect(x: 0,y: 0,width: size - 5,height: size - 5)
        ctx.addEllipse(in: circleOutsideRect)
        ctx.strokePath()
        
        // draw circle inside
        let circleRadiusInside = 50
        ctx.setLineWidth(5.0)
        ctx.setStrokeColor(UIColor.blue.cgColor)
        let circleInsideRect = CGRect(x: size/2-circleRadiusInside,y: size/2-circleRadiusInside,width: circleRadiusInside * 2,height: circleRadiusInside * 2)
        ctx.addEllipse(in: circleInsideRect)
        ctx.strokePath()
        // draw all lines
        let ang = 360 / str.count
        let STR = "__________-0123456789abcdefghijklmnopqrstuvwxyz";
        let ratio = (size - circleRadiusInside) / 2 / STR.count
        var i = 0
        let smallCircleRadius : CGFloat = 10.0
        let blue = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        for ch in str{
            let index = STR.index(of: ch)?.encodedOffset as! Int
            let center = CGPoint(x: size / 2, y: size / 2 )
            let pathIn = UIBezierPath(arcCenter: center, radius: CGFloat(circleRadiusInside), startAngle: CGFloat(ang * i), endAngle:CGFloat(ang * i), clockwise: true)
            let inPoint = pathIn.currentPoint
            
            let pathout = UIBezierPath(arcCenter: center, radius: CGFloat(circleRadiusInside + index * ratio), startAngle: CGFloat(ang * i), endAngle:CGFloat(ang * i), clockwise: true)
            let outPoint = pathout.currentPoint
            // draw line
            ctx.setLineWidth(5.0)
            ctx.setStrokeColor(UIColor.red.cgColor)
            ctx.move(to: inPoint)
            ctx.addLine(to: outPoint)
            ctx.strokePath()
            // draw small circle
            
            
            let circleInsideRect = CGRect(x: (outPoint.x - smallCircleRadius) ,y: (outPoint.y - smallCircleRadius), width: smallCircleRadius * 2,height: smallCircleRadius * 2)
            
            ctx.setLineWidth(2.0)
            ctx.setStrokeColor(blue.cgColor)
            ctx.setFillColor(blue.cgColor)
            ctx.fillEllipse(in: circleInsideRect)
            
            i += 1
        }
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
