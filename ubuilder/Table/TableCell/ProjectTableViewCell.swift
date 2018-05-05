//
//  ProjectTableViewCell.swift
//  ubuilder
//
//  Created by CO7VF2D1G1HW on 5/5/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProjectTableViewCell: TableCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTotalCost: UILabel!
    
    @IBOutlet weak var lbModuleCount: UILabel!
    var item : Project!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func initData(object: IObject) {
         self.item = object as! Project
        
        self.lbName.text = item.name
        self.imgImage.image = Util.getImage(data64: self.item.image)
        if self.item.modules.tasks.count > 0 {
            let hasS = self.item.modules.tasks.count == 1 ? "" : "s"
            self.lbModuleCount.text = "\(self.item.modules.tasks.count) module\(hasS)"
            self.lbTotalCost.text =  "\(self.item.modules.tasks.reduce(0) { $0 + $1.price.toInt() })"
        }
        else {
            self.lbModuleCount.text = "No mudoles"
            self.lbTotalCost.text = ""
        }
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
    
    static let nibName = String(describing:  ProjectTableViewCell.self)
    static let reuseIdentifier = String(describing: ProjectTableViewCell.self)
    static let height : CGFloat = 180
    
}
