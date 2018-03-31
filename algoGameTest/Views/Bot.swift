import Foundation
import UIKit

class HexagonBot: UIView {
    var cornerRadius: CGFloat = 5.0
    var color: UIColor! = UIColor(hex: 0x7289DA)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let hexarect = rect.insetBy(dx: 0, dy: rect.width * 0.2)
        // Drawing code
        let path2 = UIBezierPath()
        // two eyes, and one stick
        path2.lineCapStyle = .round
        path2.lineWidth = 5
        
        
        let stickPoint = CGPoint(x: hexarect.midX + hexarect.width * 0.2, y: rect.origin.y + hexarect.height * 0.2)
        color.setStroke()
        color.setFill()
        path2.move(to: stickPoint)
        path2.addLine(to: CGPoint(x: hexarect.midX,y: hexarect.origin.y + 7.5))
        path2.stroke()
        path2.fill()
        
        let path = UIBezierPath(polygonIn: hexarect, sides: 6, lineWidth: 4.0, cornerRadius: cornerRadius)
        
        if (rect.width < 30.0) {
            path.lineWidth = 0
        }
        else {
            path.lineWidth = rect.width / 25
        }
        
        UIColor.clear.setStroke()
        
        color.setFill()
        path.stroke()
        path.fill()
        //  self.transform =  CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
        

        // reset path
        path2.lineWidth = 2
        // eyes
        let eyeRadius = hexarect.width * 0.07 / 2
        let eyeDistance = hexarect.width * 0.06
        print(hexarect.midX - eyeDistance - eyeRadius )
        let leftEyeStartPoint = CGPoint(x: hexarect.midX - eyeDistance - eyeRadius , y: hexarect.midY )
        let rightEyeStartPoint = CGPoint(x: hexarect.midX + eyeDistance + eyeRadius , y: hexarect.midY )
        let leftEyeCenterPos = CGPoint(x: hexarect.midX - eyeDistance - eyeRadius , y: hexarect.midY + eyeRadius )
        let rightEyeCenterPos = CGPoint(x: hexarect.midX + eyeDistance + eyeRadius , y: hexarect.midY + eyeRadius )
        
        path2.move(to: leftEyeStartPoint)
        path2.addArc(withCenter: leftEyeCenterPos, radius: eyeRadius, startAngle: 0, endAngle: 360.0, clockwise: true)
        UIColor.white.setStroke()
        UIColor.white.setFill()
        path2.stroke()
        path2.fill()
        
        path2.move(to: rightEyeStartPoint)
        path2.addArc(withCenter: rightEyeCenterPos, radius: eyeRadius, startAngle: 0, endAngle: 360.0, clockwise: true)
        path2.stroke()
        UIColor.white.setFill()
        path2.fill()
        
    }
    
    
}

