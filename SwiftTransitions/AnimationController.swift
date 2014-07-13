//
//  AnimationController.swift
//  SwiftTransitions
//
//  Created by Philipp Kuecuekyan on 7/11/14.
//  Copyright (c) 2014 phi & co. All rights reserved.
//

import UIKit

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting:Bool
    var presentationDuration:Double
    var dismissalDuration:Double
    
    init()  {
        isPresenting = true
        presentationDuration = 1.0
        dismissalDuration = presentationDuration
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return isPresenting ? presentationDuration : dismissalDuration
    }
   
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        var fromVC = transitionContext .viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext .viewControllerForKey(UITransitionContextToViewControllerKey)
        var fromView = fromVC.view
        var toView = toVC.view
        
        animateTransition(transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
    }
    
    func animateTransition(transitionContext:UIViewControllerContextTransitioning!, fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView) {
        
    }
}
