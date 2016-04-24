//
//  UIViewControllerExtensions.swift
//  LifeCalc
//
//  Created by takashi on 2016/04/24.
//  Copyright © 2016年 Takashi Ikeda. All rights reserved.
//

import UIKit

extension UIViewController {
    func popoverViewController(popoverViewController : UIViewController, sourcView : UIView, delegate : UIPopoverPresentationControllerDelegate, preferredContentSize : CGSize) {
        popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        popoverViewController.preferredContentSize = preferredContentSize
        
        if let presentationController = popoverViewController.popoverPresentationController {
            presentationController.delegate = delegate
            presentationController.permittedArrowDirections = UIPopoverArrowDirection.Up
            presentationController.sourceView = sourcView
            presentationController.sourceRect = sourcView.bounds
            self.presentViewController(popoverViewController, animated: true, completion: nil)
        }
    }
    
    func initAnalysisTracker(screenName : String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screenName)
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }
}