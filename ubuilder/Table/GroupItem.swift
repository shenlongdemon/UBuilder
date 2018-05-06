//
//  GroupItem.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/6/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
class GroupItem: IObject {
    var items: NSMutableArray = NSMutableArray()
    var data: IObject!
    override init() {
        self.items = NSMutableArray()
    }
}
