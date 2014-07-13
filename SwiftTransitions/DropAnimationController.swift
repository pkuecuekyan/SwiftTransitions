//
//  DropAnimationController.swift
//  SwiftTransitions
//
//  Created by Philipp Kuecuekyan on 7/11/14.
//  Copyright (c) 2014 phi & co. All rights reserved.
//

import UIKit
import QuartzCore

class DropAnimationController: AnimationController {
    
    init()  {
        super.init()
        presentationDuration = 1.0
        dismissalDuration = 0.5
        
    }
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning!)  {
        if isPresenting {
            executeDropInAnimation(transitionContext)
        } else {
            executeDropOutAnimation(transitionContext)
        }
    }
    
    func executeDropInAnimation(transitionContext: UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext .viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext .viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = fromViewController.view
        let toView = toViewController.view
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrameForViewController(fromViewController))
        backgroundView.backgroundColor = UIColor.blackColor()

        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presenting view
        let fromSnapshotRect = fromView.bounds
        let fromSnapshotView = fromView.resizableSnapshotViewFromRect(fromSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
  
        backgroundView.addSubview(fromSnapshotView)
        
        
        // Take a snapshot of the presented view
        let toSnapshotRect = toView.bounds
        let toSnapshotView = toView.resizableSnapshotViewFromRect(toSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)

        backgroundView.addSubview(toSnapshotView)
        
        toSnapshotView.frame = CGRectOffset(toSnapshotView.frame, 0, -toSnapshotView.frame.size.height);

        UIView.animateWithDuration(presentationDuration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: .CurveEaseInOut, animations: {
                    fromSnapshotView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    fromSnapshotView.alpha = 0.5;
            }, completion: {(value: Bool) in
            })

        UIView.animateWithDuration(presentationDuration, delay: 0.25, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: .CurveEaseInOut, animations: {
                toSnapshotView.frame = CGRectOffset(toSnapshotView.frame, 0, toSnapshotView.frame.size.height);
            }, completion: {(value: Bool) in
                            toSnapshotView.removeFromSuperview()
                            fromSnapshotView.removeFromSuperview()
                            backgroundView.removeFromSuperview()
                            transitionContext.completeTransition(true)
            })
        

    }
    
    func executeDropOutAnimation(transitionContext: UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext .viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext .viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = fromViewController.view
        let toView = toViewController.view
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrameForViewController(fromViewController))
        backgroundView.backgroundColor = UIColor.blackColor()

        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presenting view
        let fromSnapshotRect = fromView.bounds
        let fromSnapshotView = fromView.resizableSnapshotViewFromRect(fromSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)

        backgroundView.addSubview(fromSnapshotView)
        
        
        // Take a snapshot of the presented view
        let toSnapshotRect = toView.bounds
        let toSnapshotView = toView.resizableSnapshotViewFromRect(toSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
 
        backgroundView.addSubview(toSnapshotView)
        
        toSnapshotView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        toSnapshotView.alpha = 0.5;
        
        UIView.animateWithDuration(dismissalDuration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: .CurveEaseInOut, animations: {
                fromSnapshotView.frame = CGRectOffset(fromSnapshotView.frame, 0, -fromSnapshotView.frame.size.height);
            }, completion: {(value: Bool) in
            })
        
        UIView.animateWithDuration(dismissalDuration, delay: 0.25, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: .CurveEaseInOut, animations: {
                toSnapshotView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                toSnapshotView.alpha = 1.0
           }, completion: {(value: Bool) in
                toSnapshotView.removeFromSuperview()
                fromSnapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        
    }


}
