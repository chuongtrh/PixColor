//
//  GenaratePaletteViewController.swift
//  livecolor
//
//  Created by Sam on 6/14/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit
import UIImageColors
import ChameleonFramework

class GenaratePaletteViewController: UIViewController {

    public var imageSource:UIImage!
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var stackView:UIStackView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
   
    @IBOutlet weak var colorView1:UIView!
    @IBOutlet weak var colorView2:UIView!
    @IBOutlet weak var colorView3:UIView!
    @IBOutlet weak var colorView4:UIView!
    @IBOutlet weak var colorView5:UIView!
    @IBOutlet weak var lbColor1:UIOutlinedLabel!
    @IBOutlet weak var lbColor2:UIOutlinedLabel!
    @IBOutlet weak var lbColor3:UIOutlinedLabel!
    @IBOutlet weak var lbColor4:UIOutlinedLabel!
    @IBOutlet weak var lbColor5:UIOutlinedLabel!

    //var colors : UIImageColors?
    
    var flatColor:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageSource != nil {
            imageView.image = imageSource
            genarateColor(flat: flatColor)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MAKR: - Helper
    func genarateColor(flat:Bool) {

        stackView.isHidden = true
        stackView.alpha = 0.0
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let colors:[UIColor] = ColorsFromImage(self.imageSource, withFlatScheme: flat)
            if colors.count > 0 {
                DispatchQueue.main.async {
                    self.colorView1.backgroundColor = colors[0]
                    self.colorView2.backgroundColor = colors[1]
                    self.colorView3.backgroundColor = colors[2]
                    self.colorView4.backgroundColor = colors[3]
                    self.colorView5.backgroundColor = colors[4]
                    
                    self.lbColor1.text = colors[0].toHexString()
                    self.lbColor2.text = colors[1].toHexString()
                    self.lbColor3.text = colors[2].toHexString()
                    self.lbColor4.text = colors[3].toHexString()
                    self.lbColor5.text = colors[4].toHexString()
                    
                    self.activityIndicator.stopAnimating()
                    self.stackView.isHidden = false
                    UIView.animate(withDuration: 0.3, delay: 0.0, options:[.transitionCrossDissolve, .curveEaseIn], animations: {
                        self.stackView.alpha = 1.0
                        
                    }, completion:nil)
                    
                }
            }
        }
        
    }
    //MARK: - OnAction
    @IBAction func onBack(_ sender : AnyObject) {
        if self.isModal {
            dismiss(animated: true, completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
}
