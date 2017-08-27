//
//  PhotoCardCell.swift
//  livecolor
//
//  Created by Sam on 6/28/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit

protocol PhotoCardCellDelegate:class {
    func tapOnCell(cell:PhotoCardCell, action:String)
}

class PhotoCardCell: UITableViewCell {

    @IBOutlet var panelView:UIView!
    @IBOutlet var imgCover:UIImageView!
    @IBOutlet var lableOwner:UILabel!
    @IBOutlet var btnNext:UIButton!
    
    
    weak open var delegate: PhotoCardCellDelegate?

    
    static func identifier() -> String {
        return "PhotoCardCellIdentifier"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        panelView.backgroundColor = UIColor.white
        btnNext.layer.shadowColor = drak_color.cgColor
        btnNext.layer.shadowOpacity = 0.5
        btnNext.layer.shadowOffset = CGSize(width: 0, height: 6)
        btnNext.layer.shadowRadius = 10
        
        imgCover.pin_updateWithProgress = true

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgCover.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(photo:UnsplashPhoto) {

        imgCover.pin_updateWithProgress = true
        imgCover.pin_setImage(from: URL(string: photo.urlRegular)!)

        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: "Photo by ", attributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:font_regular(size: 13)]))
        attString.append(NSAttributedString(string: photo.ownerName, attributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:font_medium(size: 13)]))
        lableOwner.attributedText = attString
    }
    
    //MARK: OnAction
    
    @IBAction func onCreatePalette(sender:AnyObject){
        delegate?.tapOnCell(cell: self, action: "createPatelle")
    }
}

