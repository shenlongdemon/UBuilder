//
//  MyTasksViewController.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/6/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MyTasksViewController: BaseViewController {

    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var tableAdapter : TableHAdapter!
    var items: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        self.progress.stopAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initTable() {
        let cellIdentifier = TaskTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableHAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : TaskTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            if let task = item as? Task {
                self.performSegue(withIdentifier: "mytaskdetail", sender: task)
            }
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    @IBAction func refresh(_ sender: Any) {
        self.loadData()
    }
    func loadData() {
        self.progress.startAnimating()
        let user = Store.getUser()!
        self.items.removeAllObjects()
        self.tableView.reloadData()
        WebApi.getTasksByOwnerId(id: user.id) { (list) in
            var lst = list.map({ (proj) -> GroupItem in
                let gr : GroupItem = GroupItem()
                gr.data = proj
                gr.items.addObjects(from: proj.module.tasks.filter({ (task) -> Bool in
                    return task.owner.id == user.id
                }))
                return gr
            })
            self.items.addObjects(from: lst)
            self.tableView.reloadData()
            self.progress.stopAnimating()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mytaskdetail" {
            let task = sender as! Task
            let group = self.items.first(where: { (gr) -> Bool in
                let r = gr as! GroupItem
                return r.items.contains(where: { (it) -> Bool in
                    let t = it as! Task
                    return t.id == task.id
                })
            }) as! GroupItem
            let vc = segue.destination as! TaskDetailViewController
            vc.prepareModel(project: group.data as! Project, task: task)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
