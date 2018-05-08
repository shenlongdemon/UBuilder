//
//  TaskTableViewCell.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/5/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class TaskTableViewCell: TableCell {

    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbTaskName: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbPrice: UILabel!
    var item : Task!
    
    @IBOutlet weak var imgDone: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func initData(object: IObject) {
        self.item = object as! Task
        self.lbName.text = "\(item.owner.firstName) \(item.owner.lastName)"
        self.lbTaskName.text = self.item.name
        self.lbPrice.text = self.item.price
        self.imgImage.image = Util.getImage(data64: self.item.owner.image)
        self.imgDone.image = self.item.done ? #imageLiteral(resourceName: "donetask") : #imageLiteral(resourceName: "arrow")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func getFrame() -> CGRect {
        return self.frame
    }
    
    static let nibName = String(describing:  TaskTableViewCell.self)
    static let reuseIdentifier = String(describing: TaskTableViewCell.self)
    static let height : CGFloat = 80
   
    
}
