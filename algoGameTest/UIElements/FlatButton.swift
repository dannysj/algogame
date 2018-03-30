//
//  FlatButton.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/26/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class FlatButton: UIView {
    var buttonLayer: CAShapeLayer!
    var buttonSideLayer: CAShapeLayer!
    var color: CGColor = UIColor.FlatColor.Green.mintLight.cgColor
    var sideColor: CGColor = UIColor.FlatColor.Green.mintDark.cgColor
    var offset: CGFloat = 0
    
    func initialize(color: UIColor = UIColor.FlatColor.Green.mintLight, secondaryColor: UIColor = UIColor.FlatColor.Green.mintDark) {
        self.color = color.cgColor
        self.sideColor = secondaryColor.cgColor
        let radius = self.frame.height * 0.9 / 2
        offset = radius * 0.2
        print(radius)
        print(self.frame.midX)
        print(self.frame.midY)
        buttonLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.midX, y: self.frame.midY), radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        buttonLayer.path = circlePath.cgPath
        buttonLayer.fillColor = self.color
        
        buttonSideLayer = CAShapeLayer()
        let sidePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.midX, y: self.frame.midY + offset), radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        sidePath.lineCapStyle = .round
        sidePath.lineJoinStyle = .round
        buttonSideLayer.path = sidePath.cgPath
        buttonSideLayer.fillColor = sideColor
        
        self.layer.addSublayer(buttonSideLayer)
        self.layer.addSublayer(buttonLayer)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        guard let point = touch?.location(in: self) else { return }
        guard let sublayers = self.layer.sublayers as? [CAShapeLayer] else { return }
        
        for layer in sublayers{
            if let path = layer.path, path.contains(point) {
                print(layer)
                print("Touched!")
                animate()
            }
        }
    }
    
    func animate() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = buttonLayer.position           // animate from current position ...
        animation.toValue = [buttonLayer.position.x, buttonLayer.position.y + offset * 0.8]                      // ... to whereever the new position is
        animation.duration = 0.15
        
        buttonLayer.add(animation, forKey: nil)
    }

}
