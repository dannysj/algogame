//
//  ConsoleView.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/26/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class ConsoleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initFrame() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(hex: 0xE0E0E0).cgColor
        self.backgroundColor = UIColor(hex: 0x2A4383)
        
        let upperWindowHeight = self.frame.height * 0.07
        let upperWindows = CAShapeLayer()
        let rect = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: upperWindowHeight)
        print(rect)
        print(self.bounds)
        print(self.frame)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        upperWindows.path = path.cgPath
        upperWindows.fillColor = UIColor.white.cgColor
        upperWindows.borderColor = UIColor(hex: 0xE0E0E0).cgColor
        upperWindows.borderWidth = 2
        self.layer.addSublayer(upperWindows)
        
        // 3 dots
        let dotRadius:CGFloat = upperWindowHeight * 0.35 / 2
        let redDot = CAShapeLayer()
        var dotPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.minX + dotRadius * 3, y: upperWindowHeight / 2.0), radius: dotRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        redDot.path = dotPath.cgPath
        redDot.fillColor = UIColor.FlatColor.Red.brightCoral.cgColor
        upperWindows.addSublayer(redDot)
        
        dotPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.minX + dotRadius * 6, y: upperWindowHeight / 2.0), radius: dotRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let yellowDot = CAShapeLayer()
        yellowDot.path = dotPath.cgPath
        yellowDot.fillColor = UIColor.FlatColor.Yellow.sunflowerLight.cgColor
        upperWindows.addSublayer(yellowDot)
        
        dotPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.minX + dotRadius * 9, y: upperWindowHeight / 2.0), radius: dotRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let greenDot = CAShapeLayer()
        greenDot.path = dotPath.cgPath
        greenDot.fillColor = UIColor.FlatColor.Green.mintDark.cgColor
        upperWindows.addSublayer(greenDot)
        
        
    }

}
