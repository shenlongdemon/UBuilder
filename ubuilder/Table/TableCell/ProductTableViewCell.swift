//
//  CategoryTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductTableViewCell: TableCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!

    @IBOutlet weak var lbCategory: UILabel!
    
    var item : Item!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func initData(object: IObject) {
        self.item = object as! Item
        
        self.lbName.text = "\(self.item.name)"
        self.imgImage.image = item.getImage()
        self.lbCategory.text = self.item.category.value
        
        
        
       
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
    
    //    @IBOutlet weak var lbModel: UILabel!
    //    @IBOutlet weak var lbManufacture: UILabel!
    //    @IBOutlet weak var lbLicensePlate: UILabel!
    
    
    
    
    static let nibName = String(describing:  ProductTableViewCell.self)
    static let reuseIdentifier = String(describing: ProductTableViewCell.self)
    static let height : CGFloat = 80
    
}

