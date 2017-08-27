//
//  ShimmerPhotoCardCell.swift
//  livecolor
//
//  Created by Sam on 6/30/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit
import UIView_Shimmer

class ShimmerPhotoCardCell: UITableViewCell {

    @IBOutlet var panelView:UIView!
    @IBOutlet var view1:UIView!
    @IBOutlet var view2:UIView!
    @IBOutlet var btnNext:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        panelView.backgroundColor = UIColor.white
        btnNext.layer.shadowColor = drak_color.cgColor
        btnNext.layer.shadowOpacity = 0.5
        btnNext.layer.shadowOffset = CGSize(width: 0, height: 6)
        btnNext.layer.shadowRadius = 10
    }

    static func identifier() -> String {
        return "ShimmerPhotoCardCellIdenfitifer"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        view1.stopShimmering()
        view2.stopShimmering()
    }
    func startShimmer() {
        view1.startShimmering()
        view2.startShimmering()
    }

}
