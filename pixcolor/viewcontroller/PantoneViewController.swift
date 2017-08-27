//
//  ViewController.swift
//  livecolor
//
//  Created by Sam on 5/26/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class PantoneViewController: UIViewController {

    //MARK: Outlet
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnPhotoMode: UIButton!
    
    //MAKR: Properties
    
    var arrPhotos: [Unsplash_Order:[UnsplashPhoto]] = [.latest:[],.popular:[],.oldest:[]]
    
    var page:[Unsplash_Order:Int] = [.latest:0,.popular:0,.oldest:0]
    
    var isShowShimmer:Bool = true
    
    var order_by:Unsplash_Order = .latest
    

    //MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MAKR: Helper
    func setup() {
        view.backgroundColor = background_color
        tableView.backgroundColor = UIColor.clear
        
        btnPhotoMode.layer.cornerRadius = 12
        btnPhotoMode.layer.borderWidth = 1
        btnPhotoMode.layer.borderColor = drak_color.cgColor
        
        btnPhotoMode.setTitle(order_by.rawValue.capitalized, for: .normal)

        
        loadPhoto(page: page[order_by]!, orderBy:order_by)
        
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return !self.isShowShimmer
        }
        
        tableView.addInfiniteScroll { (tableView) -> Void in
            self.loadPhoto(page: self.page[self.order_by]!, orderBy: self.order_by)
        }
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: tableView)
        }
    }
    func loadPhoto(page:Int, orderBy:Unsplash_Order) {
        UnsplashService.shared.getUnsplashPhoto(page: page, orderBy: orderBy) { (arrPhotos, error) in
            if error is NSNull {
                self.isShowShimmer = false
                self.arrPhotos[self.order_by]?.append(contentsOf: arrPhotos)
                self.tableView.reloadData()
                self.tableView.finishInfiniteScroll()
                self.page[self.order_by] = self.page[self.order_by]! + 1
            }else{
                self.isShowShimmer = true
            }
        }
    }
    //MARK: - OnAction
    @IBAction func onChangeMode(_sender:AnyObject) {
        switch order_by {
        case .popular:
            order_by = .latest
            break
        case .latest:
            order_by = .oldest
            break
        case .oldest:
            order_by = .popular
            break
        }
        
        btnPhotoMode.setTitle(order_by.rawValue.capitalized, for: .normal)
        
        loadPhoto(page: page[order_by]!, orderBy:order_by)

    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGenaratePaletteViewControllerIdentifier" {
            let vc:GenaratePaletteViewController = segue.destination as! GenaratePaletteViewController
            vc.imageSource = sender as! UIImage
        }else if segue.identifier == "ShowPhotoViewControllerIdentifier" {
            let navi:UINavigationController = segue.destination as! UINavigationController
            let vc:PhotoViewController = navi.visibleViewController as! PhotoViewController
            vc.photo = sender as! UnsplashPhoto
        }
    }
}

extension PantoneViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowShimmer ? 3 : arrPhotos[order_by]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowShimmer {
            let cell:ShimmerPhotoCardCell = tableView.dequeueReusableCell(withIdentifier: ShimmerPhotoCardCell.identifier(), for: indexPath) as! ShimmerPhotoCardCell
            cell.startShimmer()
            return cell
            
        }else {
            let cell:PhotoCardCell = tableView.dequeueReusableCell(withIdentifier: PhotoCardCell.identifier(), for: indexPath) as! PhotoCardCell
            cell.delegate = self
            
            cell.updateUI(photo: (arrPhotos[order_by]?[indexPath.row])!)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowShimmer {
            return;
        }
        
        let photo = arrPhotos[order_by]?[indexPath.row]
        self.performSegue(withIdentifier: "ShowPhotoViewControllerIdentifier", sender: photo)
    }
}

extension PantoneViewController : PhotoCardCellDelegate {
    func tapOnCell(cell: PhotoCardCell, action: String) {
        if action == "createPatelle" {
            self.performSegue(withIdentifier: "ShowGenaratePaletteViewControllerIdentifier", sender: cell.imgCover.image)
        }
    }
}

// MARK: Force Touch on Speaker Images
extension PantoneViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            
            let cell = tableView.cellForRow(at: indexPath) as! PhotoCardCell
            let viewRectInTableView = tableView.convert(cell.frame, to: view.superview)
            previewingContext.sourceRect = viewRectInTableView
            
            // configuring the view controller to show
            let photo = arrPhotos[order_by]?[indexPath.row]
            
            let vc:PhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewPhotoControllerStoryboardID") as! PhotoViewController
            vc.photo = photo
            return vc
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        viewControllerToCommit.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        navigationController?.present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    private func touchedView(view: UIView, location: CGPoint) -> Bool {
        let locationInView = view.convert(location, from: tableView)
        return view.bounds.contains(locationInView)
    }
}
