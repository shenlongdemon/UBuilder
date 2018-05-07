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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var project: Project!
    var task: Task!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.stopAnimating()
        self.initTable()
        self.imgImage.image = Util.getImage(data64: self.task.owner.image)
        self.lbOwner.text = "\(self.task.owner.firstName) \(self.task.owner.lastName)"
        self.txtType.text = self.project.type.value
         self.txtProject.text = self.project.name
        self.txtTask.text = self.task.name
        self.txtPrice.text = self.task.price
        let user  = Store.getUser()!
        self.btnAdd.isHidden = user.id != task.owner.id
        
        // Do any additional setup after loading the view.
        
        
    }
    @IBAction func complete(_ sender: Any) {
        Util.showYesNoAlert(VC: self, message: "this task is done?", yesHandle: { () in
            WebApi
            
        }) { () in
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadItems()
    }
    func loadItems()  {
        self.progress.startAnimating()
        self.items.removeAllObjects()
        self.tableView.reloadData()
        WebApi.getProjectById(id: self.project.id) { (proj) in
            if let p = proj {
                let items = p.module.tasks.first(where: { (t) -> Bool in
                    return  t.id == self.task.id
                })?.material.items ?? []
                self.items.addObjects(from: items)
                self.tableView.reloadData()
            }
            self.progress.stopAnimating()
        }
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
    func initTable() {
        let cellIdentifier = ProductTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductTableViewCell.height)
        
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
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
        else if segue.identifier == "myitems" {
            let vc = segue.destination as! MyItemsViewController
            vc.prepareModel(task: self.task, project: self.project)
        }
    }
 

}
