//
//  MainViewController.swift
//  livecolor
//
//  Created by Sam on 5/27/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit




class MainViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
    override var prefersStatusBarHidden: Bool{
        return currentPage == 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navi = segue.destination as? UINavigationController {
            if let mainPageViewController = navi.visibleViewController as? MainPageViewController {
                mainPageViewController.mainDelegate = self
            }
        }
    }
  
}



extension MainViewController: MainPageViewControllerDelegate {
    
    func mainPageViewController(mainPageViewController: MainPageViewController,
                                    didUpdatePageCount count: Int) {
    }
    
    func mainPageViewController(mainPageViewController: MainPageViewController,
                                    didUpdatePageIndex index: Int) {
        currentPage = index
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func mainPageViewController(mainPageViewController: MainPageViewController, titleAtIndex title: String, index: Int) {
        
    }
}
