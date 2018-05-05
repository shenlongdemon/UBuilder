//
//  ProductViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductViewController: BaseViewController {
    
    
    
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var item : Project!
    var action = 1
    var task: Task?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.stopAnimating()
        self.imgImage.image = self.item.getImage()
        self.lbName.text = self.item.name
        self.lbPrice.text = "\(self.item.getTotalCost())"
        self.lbType.text = self.item.type.value
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showQRCode(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        self.initTable()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        if let tsk = self.task{
            self.task = nil
            self.performSegue(withIdentifier: "taskdetail", sender: tsk)
        }
    }
    @objc func showQRCode(tapGestureRecognizer: UITapGestureRecognizer)
    {
       self.performSegue(withIdentifier: "projectcode", sender: self.item.code)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareModel(project: Project, task: Task?){
        self.item = project
        self.task = task
    }
    @IBAction func refresh(_ sender: Any) {
        self.loadData()
    }
    
    func loadData() {
        self.progress.startAnimating()
        self.items.removeAllObjects()
        self.tableView.reloadData()
        WebApi.getProjectById(id: self.item.id) { (p) in
            if let proj = p {
                self.items.addObjects(from: proj.module.tasks)
                self.tableView.reloadData()                
            }
            self.progress.stopAnimating()
        }
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
        else if segue.identifier == "projectcode" {
            let vc = segue.destination as! QRCODEViewController
            vc.prepareModel(item: sender as! String)
        }
        else if segue.identifier == "taskdetail" {
            let vc = segue.destination as! TaskDetailViewController
            vc.prepareModel(project: self.item, task: sender as! Task)
        }
        
    }
   
    func initTable() {
        let cellIdentifier = TaskTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : TaskTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            if let task = item as? Task {
                self.performSegue(withIdentifier: "taskdetail", sender: task)
            }
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
}
