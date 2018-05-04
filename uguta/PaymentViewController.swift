//
//  PaymentViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {

    @IBOutlet weak var progress: UIActivityIndicatorView!
    var item: Item!
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.stopAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func payment(_ sender: Any) {
         progress.startAnimating()
        Util.getUesrInfo { (userInfo) in
            WebApi.payment(itemId: self.item.id, userInfo: userInfo, completion: { (i) in
                if let item = i {
                    self.performSegue(withIdentifier: "buyercode", sender: item)
                }
                else {
                    Util.showOKAlert(VC: self, message: "Cannot buy this item")
                }
                 self.progress.stopAnimating()
            })
        }
    }
    func prepareModel(item: Item){
        self.item = item
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GenCodeViewController
        vc.prepareModel(item: self.item)
    }
 

}
