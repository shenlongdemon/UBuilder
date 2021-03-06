//
//  MyItemsViewController.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/6/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MyItemsViewController: BaseViewController {
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var task: Task!
    var project:Project!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.stopAnimating()
        self.initTable()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    func loadData() {
        self.progress.startAnimating()
        let user = Store.getUser()!
        self.items.removeAllObjects()
        self.tableView.reloadData()
        
        WebApi.getFreeItemsByOwnerId(userId: user.id) { (items) in
            self.items.addObjects(from: items)
            self.tableView.reloadData()
            self.progress.stopAnimating()
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initTable() {
        let cellIdentifier = ProductTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            Util.showYesNoAlert(VC: self, message: "Do you want to use it?", yesHandle: { () in
               self.addItem(item: item as! Item)
            }) { () in
                
            }

            //self.performSegue(withIdentifier: "itemdetail", sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
    }
    func addItem(item: Item){
        WebApi.addItemIntoTask(projectId: self.project.id, taskId: self.task.id, item: item) { (proj) in
            if let project = proj {
                self.back()
            }
            else {
                Util.showOKAlert(VC: self, message: "Cannot add item")
            }
        }
    }
    func prepareModel(task: Task, project: Project) {
        self.task = task
        self.project = project
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
