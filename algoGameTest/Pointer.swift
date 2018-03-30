//
//  Pointer.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class Pointer: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        //initPointer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPointer() {
        let rect = self.bounds
        
        print(self.frame)
        
        let path = UIBezierPath(polygonIn: rect, sides: 3, lineWidth: 1, borderWidth: 1, cornerRadius: 2)
        path.apply(CGAffineTransform.init(rotationAngle: CGFloat.pi))
        
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.lineWidth = 2
        
        let d = CAShapeLayer()
        d.path = path.cgPath
        d.lineCap = kCALineCapRound
        d.lineJoin = kCALineJoinRound
        d.cornerRadius = 3
        d.borderWidth = 2
        d.fillColor = UIColor.FlatColor.Red.brightCoral.cgColor
        d.borderColor = UIColor.FlatColor.Red.brightCoral.cgColor
        
        self.layer.addSublayer(d)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initPointer()
    }
    
    override func draw(_ rect: CGRect) {


    }
 

}
