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
    
    override init()  {
        super.init()
        presentationDuration = 1.0
        dismissalDuration = 0.5
        
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            executeDropInAnimation(transitionContext)
        } else {
            executeDropOutAnimation(transitionContext)
        }
    }
    
    func executeDropInAnimation(_ transitionContext: UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext .viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext .viewController(forKey: UITransitionContextViewControllerKey.to)
        
        guard let fromView = fromViewController?.view, let toView = toViewController?.view else {
            return
        }
        
        toView.frame = fromViewController!.view.frame
        
        containerView.insertSubview(toViewController!.view, belowSubview: fromViewController!.view)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrame(for: fromViewController!))
        backgroundView.backgroundColor = UIColor.black
        
        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presenting view
        let fromSnapshotRect = fromView.bounds
        let fromSnapshotView = fromView.resizableSnapshotView(from: fromSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        
        backgroundView.addSubview(fromSnapshotView!)
        
        // Take a snapshot of the presented view
        let toSnapshotRect = toView.bounds
        let toSnapshotView = toView.resizableSnapshotView(from: toSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        backgroundView.addSubview(toSnapshotView!)
        toSnapshotView?.frame = toSnapshotRect.offsetBy(dx: 0, dy: -toSnapshotRect.size.height)

        UIView.animate(withDuration: presentationDuration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: UIViewAnimationOptions(), animations: {
                    fromSnapshotView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    fromSnapshotView?.alpha = 0.5
            }, completion: {(value: Bool) in
            })

        UIView.animate(withDuration: presentationDuration, delay: 0.25, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: UIViewAnimationOptions(), animations: {
                toSnapshotView?.frame = (toSnapshotView?.frame.offsetBy(dx: 0, dy: (toSnapshotView?.frame.size.height)!))!
            }, completion: {(value: Bool) in
                            toSnapshotView?.removeFromSuperview()
                            fromSnapshotView?.removeFromSuperview()
                            backgroundView.removeFromSuperview()
                            transitionContext.completeTransition(true)
            })
        

    }
    
    func executeDropOutAnimation(_ transitionContext: UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext .viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext .viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let fromView = fromViewController?.view, let toView = toViewController?.view else {
            return
        }
        
        containerView.insertSubview((toViewController?.view)!, belowSubview: (fromViewController?.view)!)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrame(for: fromViewController!))
        backgroundView.backgroundColor = UIColor.black

        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presenting view
        let fromSnapshotRect = fromView.bounds
        let fromSnapshotView = fromView.resizableSnapshotView(from: fromSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)

        backgroundView.addSubview(fromSnapshotView!)
        
        
        // Take a snapshot of the presented view
        let toSnapshotRect = toView.bounds
        let toSnapshotView = toView.resizableSnapshotView(from: toSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
 
        backgroundView.addSubview(toSnapshotView!)
        
        toSnapshotView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        toSnapshotView?.alpha = 0.5
        
        UIView.animate(withDuration: dismissalDuration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: UIViewAnimationOptions(), animations: {
                (fromSnapshotView?.frame = (fromSnapshotView?.frame.offsetBy(dx: 0, dy: -(fromSnapshotView?.frame.size.height)!))!)!
            }, completion: {(value: Bool) in
            })
        
        UIView.animate(withDuration: dismissalDuration, delay: 0.25, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: UIViewAnimationOptions(), animations: {
                toSnapshotView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                toSnapshotView?.alpha = 1.0
           }, completion: {(value: Bool) in
                toSnapshotView?.removeFromSuperview()
                fromSnapshotView?.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        
    }


}
