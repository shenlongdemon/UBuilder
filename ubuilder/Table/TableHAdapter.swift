//
//  TableView.swift
//  EasyParking
//
//  Created by test on 7/27/17.
//  Copyright © 2017 omidx. All rights reserved.
//

import UIKit

class TableHAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var items : NSMutableArray
    var cellIdentifier: String
    var cellHeight : CGFloat
    var cellCanEdit: Bool! = true
    private var didSelectRowAt : ((IObject) -> Void)? = nil
    private var didDeleteRowAt : ((IObject) -> Void)? = nil
    private var filterPredicate : ((Any) -> Bool)? = nil
    private var sortPredicate: ((Any, Any) -> ComparisonResult)? = nil
    
    
    public var allowDeleteRow: Bool = true
    
    init(items : NSMutableArray, cellIdentifier : String, cellHeight : CGFloat){
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellHeight = cellHeight
    }
    init(items : NSMutableArray, cellIdentifier : String, cellHeight : CGFloat, cellCanEdit: Bool){
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellHeight = cellHeight
        self.cellCanEdit = cellCanEdit
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // Temp prevent edit
        
        if self.allowDeleteRow == false {
            
            if tableView.isEditing {
                return .delete
            }
            return .none
        }
        else { // True
            return .delete
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.clearsContextBeforeDrawing = true
        let child = self.items.object(at: section) as! GroupItem
        return child.items.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let child = self.items.object(at: section) as! GroupItem
        return child.data.toString()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return cellCanEdit
    }
    func onDidSelectRowAt(handle : @escaping ((IObject) -> Void))  {
        self.didSelectRowAt = handle
    }
    func onDidDeleteRowAt(handle : @escaping ((IObject) -> Void))  {
        self.didDeleteRowAt = handle
    }
    func getChild(indexPath: IndexPath) -> GroupItem {
        let child : GroupItem = self.items.object(at: indexPath.section) as! GroupItem
        return child
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! TableCell
        let child = getChild(indexPath: indexPath)
        if (child.items.count > 0){
            
            let item = child.items[indexPath.row]
            
            cell.initData(object: item as! IObject)
            cell.isHidden = !(self.filterPredicate?(item as! IObject) ?? true)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let child = getChild(indexPath: indexPath)
        if (child.items.count > 0){
            let item = child.items[indexPath.row]
            self.didDeleteRowAt?(item as! IObject)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let child = getChild(indexPath: indexPath)
        if (child.items.count > 0){
            let item = child.items[indexPath.row]
            self.didSelectRowAt?(item as! IObject)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let child = getChild(indexPath: indexPath)
        if (child.items.count > 0){
            let item = child.items[indexPath.row]
            let height : CGFloat = (self.filterPredicate?(item as! IObject) ?? true) ? self.cellHeight : 0.0
            return height
        }
        else {
            return 0.0
        }
    }
    
    
}


