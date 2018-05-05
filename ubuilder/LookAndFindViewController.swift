//
//  LookAndFindViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import AVFoundation
import UIKit
import QRCodeReader
class LookAndFindViewController: BaseViewController , QRCodeReaderViewControllerDelegate{
    var isScanning: Bool = false
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func bluetooth(_ sender: Any) {
        self.performSegue(withIdentifier: "bluetooth", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func allProducts(_ sender: Any) {
        self.performSegue(withIdentifier: "allproducts", sender: nil)
    }
    @IBAction func startScan(_ sender: Any) {
        guard checkScanPermissions() else { return }
        self.isScanning = true
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        present(readerVC, animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        reader.stopScanning()
        self.isScanning = false
        self.processQRCode(qrCode: result.value)
        dismiss(animated: true) { [weak self] in
            
        }
    }
    func processQRCode(qrCode: String) {
        if (self.isScanning == false){
            
            WebApi.getProjectOrTaskByQRCode(code: qrCode, completion: { (p, t, isProjectNotTask) in
                
                if isProjectNotTask{
                    if let project = p as? Project{
                        self.performSegue(withIdentifier: "productdetailhome", sender: project)
                    }
                }
                else {
                    if let task = t as? Task, let project = p as? Project{
                        var dic : NSMutableDictionary = NSMutableDictionary()
                        
                        dic.setValue(task, forKey: "task")
                        dic.setValue(project, forKey: "project")
                        self.performSegue(withIdentifier: "productdetailhome", sender: dic)
                    }
                }
            })
        }
        
        
        
    }
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productdetailhome" {
            let vc = segue.destination as! ProductViewController
            if let project : Project = sender as? Project {
                
                vc.prepareModel(project: sender as! Project, task: nil)
            }
            else {
                let dic = sender as! NSDictionary
                let project = dic.value(forKey: "project") as! Project
                let task = dic.value(forKey: "task") as! Task
                vc.prepareModel(project: project, task: task)
            }
        }
        
        
        
    }
    
}
