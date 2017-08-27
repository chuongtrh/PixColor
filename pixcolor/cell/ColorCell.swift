//
//  ColorCell.swift
//  livecolor
//
//  Created by Sam on 5/26/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet var colorView:UIView!
    @IBOutlet var name:UILabel!
    @IBOutlet var hex:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(_ dictData: NSDictionary){
        let name = dictData["pantone"] as! String
        let hex = dictData["hex"] as! String
        
        self.name.text = name
        self.hex.text = hex
        
        let rgb = hex.replacingOccurrences(of: "#", with: "")
        self.colorView.backgroundColor = UIColor(rgb: Int(rgb, radix: 16)!)
        
    }
}
