//
//  TaskDetailViewController.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/6/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class TaskDetailViewController: BaseViewController {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtProject: UITextField!
    
    @IBOutlet weak var btnAdd: BaseButton!
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtTask: UITextField!
    var project: Project!
    var task: Task!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgImage.image = Util.getImage(data64: self.task.owner.image)
        self.lbOwner.text = "\(self.task.owner.firstName) \(self.task.owner.lastName)"
        self.txtType.text = self.project.type.value
         self.txtProject.text = self.project.name
        self.txtTask.text = self.task.name
        self.txtPrice.text = self.task.price
        self.loadInfo()
        // Do any additional setup after loading the view.
    }
    func loadInfo()  {
        let user  = Store.getUser()!
        self.btnAdd.isHidden = user.id != task.id
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(project: Project, task: Task)  {
        self.project = project
        self.task = task
    }
    
    @IBAction func showCode(_ sender: Any) {
        self.performSegue(withIdentifier: "taskcode", sender: self.task.code)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "taskcode" {
            let vc = segue.destination as! QRCODEViewController
            vc.prepareModel(item: self.task.code)
        }
    }
 

}
