//
//  ViewController.swift
//  SwiftTransitions
//
//  Created by Philipp Kuecuekyan on 7/11/14.
//  Copyright (c) 2014 phi & co. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
                            
    @IBOutlet var cubeButton: UIButton?
    @IBOutlet var doorButton: UIButton?
    @IBOutlet var dropButton: UIButton?
    
    var animationController : AnimationController = AnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let buttonPressed = sender as! UIButton
        
        switch buttonPressed {
            case cubeButton!: animationController = CubeAnimationController()
            case doorButton!: animationController = DoorwayAnimationController()
            case dropButton!: animationController = DropAnimationController()
        default: animationController = CubeAnimationController()
            
        }
        
        self.navigationController!.delegate = self
        let toVC = segue.destination as UIViewController
        
        toVC.transitioningDelegate = self
        
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push  {
            animationController.isPresenting = true
        } else {
            animationController.isPresenting = false
        }
        return self.animationController

    }
}

