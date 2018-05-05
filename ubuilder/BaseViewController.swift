//
//  BaseViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func bactToRoot()  {
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }

}
