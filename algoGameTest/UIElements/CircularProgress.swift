//
//  CircularProgress.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/26/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class CircularProgress: CAShapeLayer {
    var progress: Float = 0
    var color: CGColor = UIColor.FlatColor.Green.mintDark.cgColor
    var radius: CGFloat = 100.0
   
    func initialize(point: CGPoint) {
        self.strokeColor = color
        self.lineCap = kCALineCapRound
        self.fillColor = UIColor.clear.cgColor
        self.lineWidth = 10
        
        let center = point
        radius = 100.0
        let startAngle = -CGFloat.pi / 2
        let endAngle = CGFloat.pi * 2 + startAngle
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle , endAngle:  endAngle, clockwise: true)
        self.path = path.cgPath
       
        self.strokeEnd = 1
        self.strokeStart = 0
        
        
        
    }
    
    func animate() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeStart")
        basicAnimation.fillMode = kCAFillModeForwards
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        basicAnimation.isRemovedOnCompletion = false
        self.add(basicAnimation, forKey: "strokeStart")
        
    }
}
