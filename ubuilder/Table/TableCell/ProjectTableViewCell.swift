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
    
    @IBOutlet weak var imgNext: UIImageView!
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
        self.imgNext.image = self.item.done ? #imageLiteral(resourceName: "donetask") : #imageLiteral(resourceName: "arrow")
        if self.item.module.tasks.count > 0 {
            self.lbModuleCount.textColor = self.item.getTaskDoneCount() == self.item.module.tasks.count ? #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1) : #colorLiteral(red: 0.9332866073, green: 0.6511869431, blue: 0.2768015563, alpha: 1)
            self.lbModuleCount.text = self.item.getModuleCountStr()
            self.lbTotalCost.text =  "\(self.item.getTotalCost())"
            
        }
        else {
            self.lbModuleCount.textColor = #colorLiteral(red: 0.9332866073, green: 0.6511869431, blue: 0.2768015563, alpha: 1)
            self.lbModuleCount.text = "No modules"
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
    static let height : CGFloat = 80
    
}
