//
//  OMIDCODEViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 5/1/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class OMIDCODEViewController: BaseViewController {
    var item: String!
    @IBOutlet weak var imgImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgImage.image = Util.drawOMIDCode(str: item)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(item: String){
        self.item = item
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
