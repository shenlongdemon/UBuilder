//
//  ProductListViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductListViewController: BaseViewController {
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var category: Category!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.stopAnimating()
        initTable()
        loadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(cat: Category){
        self.category = cat
    }
    func initTable() {
        let cellIdentifier = ProductTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: "productdetail", sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    func loadData() {
        progress.startAnimating()
        items.removeAllObjects()
        WebApi.getProductsByCategory(categoryId: self.category.id) { (list) in
            self.items.addObjects(from: list)
            self.tableView.reloadData()
            self.progress.stopAnimating()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProductViewController
        vc.prepareModel(item: sender as! Item)        
    }
 

}
