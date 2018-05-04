//
//  ProductViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductViewController: BaseViewController {
    
    
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lbPrice: UILabel!
    var item : Item!
    var action = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.stopAnimating()
        self.imgImage.image = self.item.getImage()
        self.lbName.text = self.item.name
        self.lbCategory.text = self.item.category.value
        self.lbPrice.text = self.item.price
        self.lbOwner.text = "\(self.item.owner.firstName) \(self.item.owner.lastName)"
        self.imgQR.image = Util.getQRCodeImage(str: self.item.getProductCode())
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(qrCodeImageTapped(tapGestureRecognizer:)))
        self.imgQR.isUserInteractionEnabled = true
        self.imgQR.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer1)
        
        self.makeButtonAction()
        // Do any additional setup after loading the view.
    }

    func makeButtonAction() {
        var title = "SELL"
        let user = Store.getUser()!
        
        self.btnAction.isEnabled = true
        if item.owner.id == user.id {
            action = 1
            title = "SELL"
            if (self.item.buyerCode.count > 0){
                title = ""
                action = 0
            }
            else if (self.item.sellCode.count > 0){
                title = "CANCEL"
                action = 4
            }
        }
        else if item.owner.id != user.id { // not mine
            action = 2
            title = "BUY"
            if let buyer = item.buyer {
                if buyer.id == user.id { // buyer is me --> confirm that received item
                    action = 3
                    title = "COMFIRM"
                }
            }
        }
        self.btnAction.setTitle(title, for: .normal)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(item: Item){
        self.item = item
        
    }
    @objc func qrCodeImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        WebApi.getDescriptionQRCode(code: self.item.getProductCode()) { (description) in
            Util.showOKAlert(VC: self, message: description);
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        Util.showOKAlert(VC: self, message: self.item.bluetoothCode);
        
    }
    @IBAction func doAction(_ sender: Any) {
        if (action > 0){
            if self.progress.isAnimating{
                Util.showOKAlert(VC: self, message: "Please wait.")
                return
            }
            self.progress.startAnimating()
            if action == 1{
                self.publishSell()
            }
            else if action == 2{
                self.buy()
            }
            else if action == 3{
                self.comfirm()
            }
            else if action == 4{
                self.cancelSell()
            }
        }
    }
   
    func publishSell() {
        Util.getUesrInfo { (history) in
            WebApi.publishSell(itemId: self.item.id, ownerInfo: history, completion: { (i) in
                self.progress.stopAnimating()
                if let itm = i {
                    self.performSegue(withIdentifier: "publishsell", sender: itm)
                }
                else {
                    Util.showOKAlert(VC: self, message: "Cannot publish item to sell.")
                }
            })
        }
    }
    func comfirm() {
        Util.showYesNoAlert(VC: self, message: "You received product and comfirm?", yesHandle: { () in
            WebApi.confirmReceived(itemId: self.item.id, completion: { (done) in
                self.progress.stopAnimating()
                if (done) {
                    self.bactToRoot()
                }
                else{
                    Util.showOKAlert(VC: self, message: "Error when confirm")
                }
                
            })
        }) { () in
            
        }
       
    }
    func cancelSell() {
        WebApi.cancelSell(itemId: self.item.id, completion: { (done) in
            self.progress.stopAnimating()
            if (done) {
                self.bactToRoot()
            }
            else{
                Util.showOKAlert(VC: self, message: "Error when cancelling.")
            }
            
        })
       
    }
    func buy() {
        self.performSegue(withIdentifier: "payment", sender: self.item)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "producthistory" {
            let vc = segue.destination as! HistoryViewController
            vc.prepareModel(item: sender as! Item)
        }
        else if segue.identifier == "publishsell" {
            let vc = segue.destination as! GenCodeViewController
            vc.prepareModel(item: sender as! Item)
        }
        else if segue.identifier == "payment" {
            let vc = segue.destination as! PaymentViewController
            vc.prepareModel(item: sender as! Item)
        }
        else if segue.identifier == "bluetoothcode" {
            let vc = segue.destination as! OMIDCODEViewController
            vc.prepareModel(item: sender as! Item)
        }
    }
    
    @IBAction func viewHistory(_ sender: Any) {
        if self.progress.isAnimating{
            Util.showOKAlert(VC: self, message: "Please wait")
            return
        }
        self.performSegue(withIdentifier: "producthistory", sender: self.item)
    }
    
    @IBAction func bluetoothCode(_ sender: Any) {
        self.performSegue(withIdentifier: "bluetoothcode", sender: self.item)
    }
    
}
