SwiftTransitions
================

Swift version of [Transitions](https://github.com/pkuecuekyan/Transitions), a sample catalog of animation controllers to illustrate and animate transitions between UIViewControllers (modally and those embedded in UINavigationControllers or UITabBarControllers). Shows and expands the functionality of the UIViewControllerContextTransitioning protocol. 

## How to use the sample

The project can run on iPhones or be executed in the simulator (requires iOS 8 or above). Just open the project in Xcode (6 and above).

## Usage

To use in your own projects, just drag the files in the PHIAnimationControllers folder into your own project and import the header files. Then, allocate an instance 

```swift
 let cubeAnimationController = CubeAnimationController()
```

and return it in the corresponding protocol methods

```swift
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push  {
            animationController.isPresenting = true
        } else {
            animationController.isPresenting = false
        }
        return self.animationController

    }
```

## Types of animations

+ Cube (CubeAnimationController)
+ Doorway (DoorwayAnimationController)
+ Drop-in (DropAnimationController)

