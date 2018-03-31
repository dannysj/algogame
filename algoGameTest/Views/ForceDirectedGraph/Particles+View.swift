//
//  Particles+View.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/28/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
import CoreGraphics
import QuartzCore
import UIKit

public protocol Node: Hashable {
    var position: CGPoint { get set }
    var velocity: CGPoint { get set }
    // if this is fixed position
    var fixed: Bool { get set }
    
    func tick() // for CADisplayLink update
    
}

public struct ViewNode: Node {
    public var position: CGPoint
    public var velocity: CGPoint
    public var fixed: Bool
    // to prevent crash
    public let view: Unmanaged<UIView>
    
    // explored?
    public var explored: Bool = false {
        didSet {
            if explored {
                    self.view.takeUnretainedValue().alpha = 1.0
            }
            else {
                view.takeUnretainedValue().alpha = 0.3
            }
        }
    }
    
    public init(view: UIView, fixed: Bool) {
        self.view = .passUnretained(view)
        self.velocity = .zero
        self.position = view.center
        self.fixed = fixed
        self.explored = false
    }
    
    public var hashValue: Int {
        return view.takeUnretainedValue().hashValue
    }
    
    // to boost performance
    @inline(__always)
    public func tick() {
        view.takeUnretainedValue().center = position
    }
    
}

public func ==(lhs: ViewNode, rhs: ViewNode) -> Bool {
    return lhs.view.toOpaque() == rhs.view.toOpaque()
}

// a collection of particles

fileprivate typealias Charge = (CGFloat, CGPoint)

public final class ManyNodes<T: Node>: Force {
    var strength: CGFloat = -75
    
    // minimum distance between each node
    private var distanceMin2: CGFloat = 1
    private var distanceMax2: CGFloat = CGFloat.infinity
    private var theta2: CGFloat = 0.81
    
    public func tick(alpha: CGFloat, nodes: inout Set<T>) {
        // forming a quad tree, to determine which nodes fall in which category
        let qTree = QuadTree(nodes: nodes, initial: { (strength, $0.position) }) { (children) -> Charge in
            var value = children.reduce((0, .zero), { (acc, child) -> Charge in
                guard let value = child?.value else {
                    return acc
                }
                return (acc.0 + value.0 , acc.1 + (value.0 * value.1))
            })
            value.1 /= value.0
            return value
            
        }
        
        for var n in nodes {
            guard !n.fixed else {
                continue
            }
         // calculating the positions of the nodes
            qTree?.visit({ (quad) -> Bool in
                let val = quad.value
                let width = quad.bounds.width
                let delta = (val.1 - n.position).jiggled
                
                var d2 = pow(delta.x, 2) + pow(delta.y, 2)
                if d2 < distanceMin2 {
                    d2 = sqrt(distanceMin2 * d2)
                }
                
                // Following is barnes-Hut approximation
                let bh = ( pow(width, 2) / theta2 < d2)
                
                if (bh || quad.leaf) && d2 < distanceMax2 {
                    n.velocity += (delta * alpha * val.0 / d2)
                }
                return bh
            })
            nodes.update(with: n)
        }
    }
}

/* Used inner function */

@inline(__always)
internal func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint  {
    return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

@inline(__always)
internal func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint  {
    return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
}

@inline(__always)
internal func *= (lhs: inout CGPoint, rhs: CGFloat)  {
    lhs = lhs * rhs
}

