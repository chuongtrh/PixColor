//
//  MainViewController.swift
//  livecolor
//
//  Created by Sam on 5/27/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit



class MainPageViewController: UIPageViewController {

    
    //MARK: Properties

    weak var mainDelegate: MainPageViewControllerDelegate?

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("Camera"),
                self.newColoredViewController("Pantone")]
    }()
    
    
    private(set) lazy var titleViewControllers: [String] = {
        return ["Camera","Discover"]
    }()

    var currentIndex:Int = 1
    
    //MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
                
        
        let firstViewController:UIViewController = orderedViewControllers[1]
        setViewControllers([firstViewController],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    
        
        
        mainDelegate?.mainPageViewController(mainPageViewController: self, didUpdatePageCount: orderedViewControllers.count)
        mainDelegate?.mainPageViewController(mainPageViewController: self, titleAtIndex: titleViewControllers[currentIndex], index: currentIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Private function

    private func newColoredViewController(_ color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)ViewController")
    }

}


extension MainPageViewController: UIPageViewControllerDelegate {
    
    // MARK: UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            
            currentIndex = index
            mainDelegate?.mainPageViewController(mainPageViewController: self, didUpdatePageIndex: index)
            mainDelegate?.mainPageViewController(mainPageViewController: self, titleAtIndex: titleViewControllers[index], index: index)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){

        if let firstViewController = pendingViewControllers.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            mainDelegate?.mainPageViewController(mainPageViewController: self, titleAtIndex: titleViewControllers[index], index: index)
        }

    }
}

extension MainPageViewController: UIPageViewControllerDataSource {

    // MARK: UIPageViewControllerDataSource

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}


protocol MainPageViewControllerDelegate: class {
    
    func mainPageViewController(mainPageViewController: MainPageViewController,
                                didUpdatePageCount count: Int)
    
    func mainPageViewController(mainPageViewController: MainPageViewController,
                                didUpdatePageIndex index: Int)

    func mainPageViewController(mainPageViewController: MainPageViewController,
                                titleAtIndex title: String, index: Int)

}

