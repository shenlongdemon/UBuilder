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
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbModuleCount: UILabel!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var item : Project!
    var action = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.stopAnimating()
        self.imgImage.image = self.item.getImage()
        self.lbName.text = self.item.name
        self.lbPrice.text = "\(self.item.getTotalCost())"
        self.lbModuleCount.text = self.item.getModuleCountStr()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(item: Project){
        self.item = item
        
    }
    @IBAction func refresh(_ sender: Any) {
    }
    
    @IBAction func addTask(_ sender: Any) {
        self.performSegue(withIdentifier: "addtask", sender: self.item)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addtask" {
            let vc = segue.destination as! FillTaskViewController
            vc.prepareModel(item: sender as! Project)
        }
    }
   
    
}
