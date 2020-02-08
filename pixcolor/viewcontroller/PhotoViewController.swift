//
//  PhotoViewController.swift
//  livecolor
//
//  Created by Sam on 6/29/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    //MARK: Outlet
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var btnNext:UIButton!

    
    //MARK: Properties
    public var photo:UnsplashPhoto!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.layer.shadowColor = drak_color.cgColor
        btnNext.layer.shadowOpacity = 0.5
        btnNext.layer.shadowOffset = CGSize(width: 0, height: 6)
        btnNext.layer.shadowRadius = 10
        
        img.pin_updateWithProgress = true

        if photo != nil {
            img.pin_setImage(from: URL(string: photo.urlRegular)!)
            
            let attString = NSMutableAttributedString()
            attString.append(NSAttributedString(string: "Photo by\n", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:font_regular(size: 13)]))
            attString.append(NSAttributedString(string: photo.ownerName, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:font_medium(size: 14)]))
            lbTitle.attributedText = attString

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - OnAction
    @IBAction func onBack(_ sender : AnyObject) {
        dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCreatePalette(sender:AnyObject){
        self.performSegue(withIdentifier: "ShowGenaratePaletteViewControllerIdentifier", sender: img.image)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGenaratePaletteViewControllerIdentifier" {
            let vc:GenaratePaletteViewController = segue.destination as! GenaratePaletteViewController
            vc.imageSource = sender as! UIImage
        }
    }

}
