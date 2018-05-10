//
//  FillTaskViewController.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/5/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import AVFoundation
import UIKit
import QRCodeReader

class FillTaskViewController: BaseViewController, QRCodeReaderViewControllerDelegate {
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
    @IBOutlet weak var lbEmployeeName: UILabel!
    
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var txtProjectName: UITextField!
    @IBOutlet weak var imgImage: UIImageView!
    var item: Project!
    var employee: User? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtType.text = self.item.type.value
        self.txtProjectName.text = self.item.name
        self.progress.stopAnimating()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startQRCode(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startQRCode(tapGestureRecognizer: UITapGestureRecognizer)
    {
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
    func prepareModel(item: Project)  {
        self.item = item
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.getEmployee(qrCode: "d1b3ebd6-0db5-47e1-8a4e-d7e4b60d0769");
    }
    @IBAction func save(_ sender: Any) {
        let task : Task = Task()
        task.name = txtTaskName.text!
        task.price = txtPrice.text!
        task.owner = self.employee!
        self.progress.startAnimating()
        WebApi.addTask(projectId: self.item.id, task: task) { (done) in
            if done {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                Util.showOKAlert(VC: self, message: "Error")
            }
            self.progress.stopAnimating()
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
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        
        
        
        reader.stopScanning()
        self.isScanning = false
        self.processQRCode(qrCode: result.value)
        
        dismiss(animated: true) { [weak self] in
            
        }
    }
    func loadEmployeeInfo(){
        guard let user = employee else {
            return
        }
        self.imgImage.image = Util.getImage(data64: user.image ?? "")
        self.lbEmployeeName.text = "\(user.firstName) \(user.lastName)"
    }
    func processQRCode(qrCode: String) {
        if (self.isScanning == false){
            self.getEmployee(qrCode: qrCode)
        }
    }
    func getEmployee(qrCode: String){
        WebApi.getUserById(userId: qrCode) { (u) in
            guard let usr = u else { /* Handle nil case */ return }
            self.employee = usr
            self.loadEmployeeInfo()
        }
    }
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

}
