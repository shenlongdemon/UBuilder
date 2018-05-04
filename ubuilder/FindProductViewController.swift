//
//  FindProductViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class FindProductViewController: BaseViewController {
    
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.stopAnimating()
        initTable()
        // Do any additional setup after loading the view.
    }
    func loadData() {
        progress.startAnimating()
        items.removeAllObjects()
        WebApi.getCategories { (list) in
            self.items.addObjects(from: list)
            self.tableView.reloadData()
            self.progress.stopAnimating()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func initTable() {
        let cellIdentifier = CategoryTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : CategoryTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: "productlist", sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProductListViewController
        vc.prepareModel(cat: sender as! Category)
    }
    

}
