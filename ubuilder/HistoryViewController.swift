//
//  HistoryViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var item : Item!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareModel(item: Item){
        self.item = item
        self.items.removeAllObjects()
        var arr = self.item.section.history
        if (arr.count > 0){
            let product = arr[0]
            product.index = -1
        }
        if let buyer = self.item.buyer {
            buyer.index = 1
            arr.append(buyer)
        }
        
        let array : [History] = Array(arr.reversed())
        
        self.items.addObjects(from: array)
    }
    func initTable() {
        let cellIdentifier = HistoryTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : HistoryTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
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
