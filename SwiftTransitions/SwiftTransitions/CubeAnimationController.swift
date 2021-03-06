//
//  CubeAnimationController.swift
//  SwiftTransitions
//
//  Created by Philipp Kuecuekyan on 7/11/14.
//  Copyright (c) 2014 phi & co. All rights reserved.
//

import UIKit
import QuartzCore

enum CubeDirection {
    case turnLeft
    case turnRight
}

class CubeAnimationController: AnimationController {
    
    override init()  {
        super.init()
        presentationDuration = 0.6
        dismissalDuration = presentationDuration
        
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            executeCubeAnimation(transitionContext, direction: CubeDirection.turnRight)
        } else {
            executeCubeAnimation(transitionContext, direction: CubeDirection.turnLeft)
        }
    }
 
    func executeCubeAnimation(_ transitionContext: UIViewControllerContextTransitioning!, direction: CubeDirection) {
        
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
        
        // Take a snapshot of the presenting view
        let fromSnapshotRect = fromView.bounds
        guard let fromSnapshotView = fromView.resizableSnapshotView(from: fromSnapshotRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero) else {
            return
        }
        fromSnapshotView.layer.anchorPointZ = -((fromSnapshotView.frame.size.width) / 2)
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = -1.0 / 1000
        transform = CATransform3DTranslate(transform, 0, 0, (fromSnapshotView.layer.anchorPointZ))
        fromSnapshotView.layer.transform = transform
        fromSnapshotView.layer.borderColor = UIColor.black.cgColor
        fromSnapshotView.layer.borderWidth = 2.0
        
        backgroundView.addSubview(fromSnapshotView)

        // Take a snapshot of the presented view
        let toSnapshotRect = toView.bounds
        guard let toSnapshotView = toView.resizableSnapshotView(from: toSnapshotRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero) else {
            return
        }
        toSnapshotView.layer.anchorPointZ = -((toSnapshotView.frame.size.width) / 2)
        transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000
        transform = CATransform3DTranslate(transform, 0, 0, (toSnapshotView.layer.anchorPointZ))
        toSnapshotView.layer.transform = transform
 
        backgroundView.insertSubview(toSnapshotView, belowSubview:fromSnapshotView)
        
        if direction == CubeDirection.turnLeft {
            toSnapshotView.layer.transform = CATransform3DRotate((toSnapshotView.layer.transform), CGFloat(-Double.pi/2), 0, 1, 0)
        } else {
            toSnapshotView.layer.transform = CATransform3DRotate((toSnapshotView.layer.transform), CGFloat(Double.pi / 2), 0, 1, 0)
        }
        
        UIView.animate(withDuration: presentationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                if direction == CubeDirection.turnLeft {
                    toSnapshotView.layer.transform = CATransform3DRotate((toSnapshotView.layer.transform), CGFloat(Double.pi / 2), 0, 1, 0)
                    fromSnapshotView.layer.transform = CATransform3DRotate((fromSnapshotView.layer.transform), CGFloat(Double.pi / 2), 0, 1, 0)
                } else {
                    toSnapshotView.layer.transform = CATransform3DRotate((toSnapshotView.layer.transform), CGFloat(-Double.pi / 2), 0, 1, 0)
                    fromSnapshotView.layer.transform = CATransform3DRotate((fromSnapshotView.layer.transform), CGFloat(-Double.pi / 2), 0, 1, 0)
                }

            }, completion: {(value: Bool) in
                fromSnapshotView.removeFromSuperview()
                toSnapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })

    }
    
}
