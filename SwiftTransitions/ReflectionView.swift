//
//  ReflectionView.swift
//  SwiftTransitions
//
//  Created by Philipp Kuecuekyan on 7/11/14.
//  Copyright (c) 2014 phi & co. All rights reserved.
//

import UIKit
import QuartzCore

class ReflectionView: UIView {

    init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    override class func layerClass() -> AnyClass {
        return CAReplicatorLayer.self
    }
  
    func setUp() {
        var layer = self.layer as CAReplicatorLayer;
        layer.instanceCount = 2;
    
        // Move and invert reflection
        var transform : CATransform3D = CATransform3DIdentity;
        var verticalOffset:CGFloat = self.bounds.size.height + 2;
        transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
        transform = CATransform3DScale(transform, 1, -1, 0);
        layer.instanceTransform = transform;
    
        // Dim reflection
        layer.instanceAlphaOffset = -0.6;

    }
    
}