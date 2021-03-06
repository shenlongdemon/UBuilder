//
//  QRCODEViewController.swift
//  ubuilder
//
//  Created by Long Nguyen on 5/4/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import QRCode
class QRCODEViewController: BaseViewController {
    var item: String!
    
    @IBOutlet weak var imgImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let qrCode = QRCode(item!)
        self.imgImage.image = qrCode?.image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(qrCodeImageTapped(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func qrCodeImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        WebApi.getDescriptionQRCode(code: self.item) { (description) in
            Util.showOKAlert(VC: self, message: description);
        }
    }

    @IBAction func omidCode(_ sender: Any) {
        self.performSegue(withIdentifier: "omidcode", sender: self.item)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! OMIDCODEViewController
        vc.prepareModel(item: self.item)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func prepareModel(item: String){
        self.item = item
    }
    
}
