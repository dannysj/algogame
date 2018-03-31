//
//  FlatButton.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/26/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

enum ButtonType {
    case Alert
    case Info
    case Ok
    case Close
}

class FlatButton: UIView {
    var buttonLayer: CAShapeLayer!
    var buttonSideLayer: CAShapeLayer!
    var color: CGColor = UIColor.FlatColor.Green.mintLight.cgColor
    var sideColor: CGColor = UIColor.FlatColor.Green.mintDark.cgColor
    var offset: CGFloat = 0
    var buttonType: ButtonType!
    
    func initType(type: ButtonType) {
        self.buttonType = type
        switch type {
        case .Alert:
            initialize(color: UIColor.FlatColor.Red.grapeFruit, secondaryColor: UIColor.FlatColor.Red.grapeFruitDark)
            addText(text: "!")
        case .Info:
            initialize(color: UIColor.FlatColor.Blue.blueJeans, secondaryColor: UIColor.FlatColor.Blue.darkerBlueJeans)
            addText(text: "i")
        case .Ok:
            initialize()
            addText(text: "OK")
        case .Close:
            initialize(color: UIColor.white, secondaryColor: UIColor.FlatColor.White.lightGray)
            addText(text: "X")
        }
    }
    
    func initialize(color: UIColor = UIColor.FlatColor.Green.mintLight, secondaryColor: UIColor = UIColor.FlatColor.Green.mintDark) {
        self.color = color.cgColor
        self.sideColor = secondaryColor.cgColor
        let radius = self.frame.height * 0.9 / 2
        offset = radius * 0.2
        print(radius)
        print(self.frame.midX)
        print(self.frame.midY)
        buttonLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY - offset / 2), radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        buttonLayer.path = circlePath.cgPath
        buttonLayer.fillColor = self.color
        
        buttonSideLayer = CAShapeLayer()
        let sidePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY + offset / 2), radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        sidePath.lineCapStyle = .round
        sidePath.lineJoinStyle = .round
        buttonSideLayer.path = sidePath.cgPath
        buttonSideLayer.fillColor = sideColor
        
        self.layer.addSublayer(buttonSideLayer)
        self.layer.addSublayer(buttonLayer)
        
    }
    
    func addText(text: String) {
        let label = UILabel()
        
        switch buttonType {
            case .Alert:
               label.textColor = UIColor.FlatColor.Red.alizarinCrimson
               label.font = UIFont(name: "Menlo-Bold", size: 40)
            case .Info:
                label.textColor = UIColor.FlatColor.Blue.riptide
                label.font = UIFont(name: "Menlo-Bold", size: 40)
            case .Ok:
                label.textColor = UIColor.white
                label.font = UIFont(name: "Menlo-Regular", size: 35)
            case .Close:
                label.textColor = UIColor.clear
                label.font = UIFont(name: "Menlo-Bold", size: 40)
            default:
                fatalError()
        }
        label.textAlignment = .center
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: self.heightAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
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
