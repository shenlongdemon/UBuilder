//
//  HistoryTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class HistoryTableViewCell: TableCell {

    @IBOutlet weak var txtDescription: UITextView!
    var item : History!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDescription: UITextView!
    @IBOutlet weak var imgImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func initData(object: IObject) {
        self.item = object as! History
        self.imgImage.image = self.item.getImage()
        self.lbName.text = "\(self.item.firstName) \(self.item.lastName) "
        self.txtDescription.text = self.getDescription()
    }
    func getDescription() -> String {
        
        var action = ""
        let milisecond = self.item.time
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm"
        let at = dateFormatter.string(from: dateVar)
        if (self.item.index == -1){
            action = "Produced"
        }
        else if (self.item.index == 1){
            action = "Sold"
        }
        else {
            action = "Purchased"
        }
        let str = "\(action) on \(at) \nAddress: \(self.item.weather.sys.country)"
        return str
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
    
    
    
    
    static let nibName = String(describing:  HistoryTableViewCell.self)
    static let reuseIdentifier = String(describing: HistoryTableViewCell.self)
    static let height : CGFloat = 140
    
}
