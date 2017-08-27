//
//  UIViewController.swift
//  livecolor
//
//  Created by Sam on 6/29/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var isModal: Bool {
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}
