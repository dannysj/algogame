//
//  Pointer.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class Pointer: UIView {

    func initPointer() {
        let rect = self.bounds
        
        print(rect)
        let d = CAShapeLayer()
        d.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        d.position = CGPoint(x: self.layer.bounds.midX, y: self.layer.bounds.midY)
       
        let path = UIBezierPath(polygonIn: CGRect(x: -rect.width / 2, y: -rect.height / 2, width: rect.width, height: rect.height   ), sides: 3, lineWidth: 1, borderWidth: 1, cornerRadius: 2)
        
        //path.apply(CGAffineTransform.init(rotationAngle: CGFloat.pi))
        
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.lineWidth = 2
        
        d.path = path.cgPath
        d.lineCap = kCALineCapRound
        d.lineJoin = kCALineJoinRound
        d.cornerRadius = 3
        d.borderWidth = 2
        d.fillColor = UIColor.FlatColor.Red.brightCoral.cgColor
        d.borderColor = UIColor.FlatColor.Red.brightCoral.cgColor
        d.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat.pi))
        d.affineTransform()
        
        self.layer.addSublayer(d)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initPointer()
    }

}
