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
    
    override init()  {
        isPresenting = true
        presentationDuration = 1.0
        dismissalDuration = presentationDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? presentationDuration : dismissalDuration
    }
   
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        animateTransition(transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView!, toView: toView!)
    }
    
    func animateTransition(_ transitionContext:UIViewControllerContextTransitioning!, fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView) {
        
    }
}
