//
//  Center+Force.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/28/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol Force {
    associatedtype Subject: Node
    func tick(alpha: CGFloat, nodes: inout Set<Subject>)
}

public final class Center<T: Node>: Force {
    public var center: CGPoint
    public init(center: CGPoint) {
        self.center = center
    }
    
    public func tick(alpha: CGFloat, nodes: inout Set<T>) {
        let delta = self.center - (nodes.reduce(.zero, {$0 + $1.position}) / CGFloat(nodes.count))
        for var n in nodes {
            if n.fixed {
                continue
            }
            
            // update position
            n.position += delta
            nodes.update(with: n)
        }
    }
}



/* MARK: Internal function */
// addition, easier
@inline(__always)
internal func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint  {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
@inline(__always)
internal func += (lhs: inout CGPoint, rhs: CGPoint)  {
    lhs = lhs + rhs
}

// minus
@inline(__always)
internal func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint  {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
@inline(__always)
internal func -= (lhs: inout CGPoint, rhs: CGPoint)  {
    lhs = lhs - rhs
}

// For dividing a point with CGFloat, easier to write
@inline(__always)
internal func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint  {
    return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}

@inline(__always)
internal func /= (lhs: inout CGPoint, rhs: CGFloat)  {
    lhs = lhs / rhs
}


