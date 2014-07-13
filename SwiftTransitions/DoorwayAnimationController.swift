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
    
    init()  {
        super.init()
        presentationDuration = 1.0
        dismissalDuration = presentationDuration
        
    }

    override func animateTransition(transitionContext:UIViewControllerContextTransitioning!, fromVC:UIViewController, toVC:UIViewController, fromView:UIView, toView:UIView) {
        
        if isPresenting {
            executeDoorwayInAnimation(transitionContext)
        } else {
            executeDoorwayOutAnimation(transitionContext)
        }

    }

    func executeDoorwayInAnimation(transitionContext:UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController.view
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController.view
        let containerView = transitionContext.containerView()

        containerView.addSubview(toViewController.view)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrameForViewController(fromViewController))
        backgroundView.backgroundColor = UIColor.blackColor()

        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presenting view: left
        let fromLeftSnapshotRect = CGRectMake(0.0, 0.0, fromView.frame.size.width / 2, fromView.frame.size.height);
        let fromLeftSnapshotView = fromView.resizableSnapshotViewFromRect(fromLeftSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        fromLeftSnapshotView.frame = fromLeftSnapshotRect
 
        backgroundView.addSubview(fromLeftSnapshotView)
        
        // Take a snapshot of the presenting view: right
        let fromRightSnapshotRect = CGRectMake(fromView.frame.size.width / 2, 0.0, fromView.frame.size.width / 2, fromView.frame.size.height);
        let fromRightSnapshotView = fromView.resizableSnapshotViewFromRect(fromRightSnapshotRect, afterScreenUpdates:false, withCapInsets:UIEdgeInsetsZero)
        fromRightSnapshotView.frame = fromRightSnapshotRect;
  
        backgroundView.addSubview(fromRightSnapshotView)
        
        // Take a snapshot of the presented view
        let toSnapshotRect = containerView.frame;
        let toSnapshotView = ReflectionView(frame:toSnapshotRect)
        toSnapshotView.addSubview(toView.resizableSnapshotViewFromRect(toSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero))
        var scale:CATransform3D = CATransform3DIdentity
        toSnapshotView.layer.transform = CATransform3DScale(scale, kDoorwayZoomScale, kDoorwayZoomScale, 1)
  
        backgroundView.addSubview(toSnapshotView)
        
        UIView.animateWithDuration(presentationDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
                toSnapshotView.layer.transform = CATransform3DScale(scale, 1.0, 1.0, 1);
                toSnapshotView.alpha = 1.0
                fromLeftSnapshotView.frame = CGRectOffset(fromLeftSnapshotView.frame, -fromLeftSnapshotView.frame.size.width, 0)
                fromRightSnapshotView.frame = CGRectOffset(fromRightSnapshotView.frame, fromRightSnapshotView.frame.size.width, 0)

            }, completion: {(value: Bool) in
                fromLeftSnapshotView.removeFromSuperview()
                fromRightSnapshotView.removeFromSuperview()
                toSnapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        
    }
    
    func executeDoorwayOutAnimation(transitionContext:UIViewControllerContextTransitioning!) {
        
        // Hold onto views, VCs, contexts, frames
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController.view
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController.view
        let containerView = transitionContext.containerView()
  
        containerView.addSubview(toViewController.view)
        
        // Create a transition background view
        let backgroundView = UIView(frame: transitionContext.initialFrameForViewController(fromViewController))
        backgroundView.backgroundColor = UIColor.blackColor()

        containerView.addSubview(backgroundView)
        
        // Take a snapshot of the presented view: left
        let toLeftSnapshotRect = CGRectMake(0.0, 0.0, toView.frame.size.width / 2, toView.frame.size.height)
        let toLeftSnapshotView = toViewController.view.resizableSnapshotViewFromRect(toLeftSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        toLeftSnapshotView.frame = toLeftSnapshotRect
        toLeftSnapshotView.frame = CGRectOffset(toLeftSnapshotView.frame, -toLeftSnapshotView.frame.size.width, 0)
 
        backgroundView.addSubview(toLeftSnapshotView)
        
        // Take a snapshot of the presented view: right
        let toRightSnapshotRect = CGRectMake(toView.frame.size.width / 2, 0.0, toView.frame.size.width / 2, fromView.frame.size.height)
        let toRightSnapshotView = toViewController.view.resizableSnapshotViewFromRect(toRightSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        toRightSnapshotView.frame = toRightSnapshotRect
        toRightSnapshotView.frame = CGRectOffset(toRightSnapshotView.frame, toRightSnapshotView.frame.size.width, 0);
 
        backgroundView.addSubview(toRightSnapshotView);
        
        // Take a snapshot of the presenting view
        var fromSnapshotRect = containerView.frame
        let fromSnapshotView = ReflectionView(frame:fromSnapshotRect);
        fromSnapshotView.addSubview(fromView.resizableSnapshotViewFromRect(fromSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero))

        backgroundView.addSubview(fromSnapshotView)
        
        UIView.animateWithDuration(dismissalDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
                fromSnapshotView.transform = CGAffineTransformMakeScale(self.kDoorwayZoomScale, self.kDoorwayZoomScale);
                fromSnapshotView.alpha = 0.0;
                toLeftSnapshotView.frame = CGRectOffset(toLeftSnapshotView.frame, toLeftSnapshotView.frame.size.width, 0);
                toRightSnapshotView.frame = CGRectOffset(toRightSnapshotView.frame, -toRightSnapshotView.frame.size.width, 0);

            }, completion: {(value: Bool) in
                fromSnapshotView.removeFromSuperview()
                toLeftSnapshotView.removeFromSuperview()
                toRightSnapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
    }
    
}
