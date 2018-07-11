//
//  DoorwayAnimationController.swift
//  SwiftTransitions
//
//  Created by Philipp Kuecuekyan on 7/11/14.
//  Copyright (c) 2014 phi & co. All rights reserved.
//

import UIKit
import QuartzCore

class DoorwayAnimationController: AnimationController {

    let kDoorwayZoomScale:CGFloat = 0.1
    
    override convenience init()  {
        self.init(forPresentationDuration: 1.0, forDismissalDuration: 1.0)
    }

    init(forPresentationDuration presentDuration: TimeInterval, forDismissalDuration dismissDuration: TimeInterval) {
        super.init()
        self.presentationDuration = presentDuration
        self.dismissalDuration = dismissDuration
    }
    
    override func animateTransition(_ transitionContext:UIViewControllerContextTransitioning!, fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView) {
        
        if isPresenting {
            executeDoorwayInAnimation(transitionContext)
        } else {
            executeDoorwayOutAnimation(transitionContext)
        }

    }

    func executeDoorwayInAnimation(_ transitionContext:UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        let containerView = transitionContext.containerView
        
        guard
            let fromViewController = transitionContext .viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext .viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromView = fromViewController.view,
            let toView = toViewController.view else {
            return 
        }
        
        toView.frame = fromViewController.view.frame
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrame(for: fromViewController))
        backgroundView.backgroundColor = UIColor.black
        
        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presenting view: left
        let fromLeftSnapshotRect = CGRect(x: 0.0, y: 0.0, width: (fromView.frame.size.width) / 2, height: (fromView.frame.size.height))
        let fromLeftSnapshotView = fromView.resizableSnapshotView(from: fromLeftSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        fromLeftSnapshotView?.frame = fromLeftSnapshotRect
 
        backgroundView.addSubview(fromLeftSnapshotView!)
        
        // Take a snapshot of the presenting view: right
        let fromRightSnapshotRect = CGRect(x: (fromView.frame.size.width) / 2, y: 0.0, width: (fromView.frame.size.width) / 2, height: (fromView.frame.size.height))
        let fromRightSnapshotView = fromView.resizableSnapshotView(from: fromRightSnapshotRect, afterScreenUpdates:false, withCapInsets:UIEdgeInsets.zero)
        fromRightSnapshotView?.frame = fromRightSnapshotRect
  
        backgroundView.addSubview(fromRightSnapshotView!)
        
        // Take a snapshot of the presented view
        let toSnapshotRect = containerView.frame
        let toSnapshotView = ReflectionView(frame:toSnapshotRect)
        toSnapshotView.addSubview((toView.resizableSnapshotView(from: toSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)!))
        let scale:CATransform3D = CATransform3DIdentity
        toSnapshotView.layer.transform = CATransform3DScale(scale, kDoorwayZoomScale, kDoorwayZoomScale, 1)
  
        backgroundView.addSubview(toSnapshotView)
        
        UIView.animate(withDuration: presentationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                toSnapshotView.layer.transform = CATransform3DScale(scale, 1.0, 1.0, 1)
                toSnapshotView.alpha = 1.0
                fromLeftSnapshotView?.frame = (fromLeftSnapshotView?.frame.offsetBy(dx: -(fromLeftSnapshotView?.frame.size.width)!, dy: 0))!
                fromRightSnapshotView?.frame = (fromRightSnapshotView?.frame.offsetBy(dx: (fromRightSnapshotView?.frame.size.width)!, dy: 0))!

            }, completion: {(value: Bool) in
                fromLeftSnapshotView?.removeFromSuperview()
                fromRightSnapshotView?.removeFromSuperview()
                toSnapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        
    }
    
    func executeDoorwayOutAnimation(_ transitionContext:UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        guard
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toView = toViewController.view,
            let fromView = fromViewController.view else {
            return
        }
        let containerView = transitionContext.containerView
  
        containerView.addSubview(toViewController.view)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrame(for: fromViewController))
        backgroundView.backgroundColor = UIColor.black

        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presented view: left
        let toLeftSnapshotRect = CGRect(x: 0.0, y: 0.0, width: (toView.frame.size.width) / 2, height: (toView.frame.size.height))
        guard let toLeftSnapshotView = toView.resizableSnapshotView(from: toLeftSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero) else {
            return
        }
        toLeftSnapshotView.frame = toLeftSnapshotRect
        toLeftSnapshotView.frame = (toLeftSnapshotView.frame.offsetBy(dx: -(toLeftSnapshotView.frame.size.width), dy: 0))
 
        backgroundView.addSubview(toLeftSnapshotView)
        
        // Take a snapshot of the presented view: right
        let toRightSnapshotRect = CGRect(x: (toView.frame.size.width) / 2, y: 0.0, width: (toView.frame.size.width) / 2, height: (fromView.frame.size.height))
        guard let toRightSnapshotView = toView.resizableSnapshotView(from: toRightSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero) else {
            return
        }
        toRightSnapshotView.frame = toRightSnapshotRect
        toRightSnapshotView.frame = (toRightSnapshotView.frame.offsetBy(dx: (toRightSnapshotView.frame.size.width), dy: 0))
 
        backgroundView.addSubview(toRightSnapshotView)
        
        // Take a snapshot of the presenting view
        let fromSnapshotRect = containerView.frame
        let fromSnapshotView = ReflectionView(frame:fromSnapshotRect)
        fromSnapshotView.addSubview((fromView.resizableSnapshotView(from: fromSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!))

        backgroundView.addSubview(fromSnapshotView)
        
        UIView.animate(withDuration: dismissalDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                fromSnapshotView.transform = CGAffineTransform(scaleX: self.kDoorwayZoomScale, y: self.kDoorwayZoomScale)
                fromSnapshotView.alpha = 0.0
                toLeftSnapshotView.frame = (toLeftSnapshotView.frame.offsetBy(dx: (toLeftSnapshotView.frame.size.width), dy: 0))
                toRightSnapshotView.frame = (toRightSnapshotView.frame.offsetBy(dx: -(toRightSnapshotView.frame.size.width), dy: 0))

            }, completion: {(value: Bool) in
                transitionContext.completeTransition(true)
                fromSnapshotView.removeFromSuperview()
                toLeftSnapshotView.removeFromSuperview()
                toRightSnapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
            })
    }
    
}
