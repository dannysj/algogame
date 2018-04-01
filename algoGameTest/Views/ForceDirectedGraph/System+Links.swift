//
//  Links.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/28/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
import CoreGraphics

public class System<T: Node>: Force {
    typealias Degrees = Dictionary<T, UInt>
    var distance: CGFloat = 50
    
    private var deg: Degrees = [:]
    private var links: Set<Link<T>> = []
    
    // to link & not linking a system
    public func link(from: T, to: T, distance: CGFloat? = nil, strength: CGFloat? = nil, transparent: Bool = false, halfway: Bool = false) {
        //try to check if this is not exist
        guard links.update(with: Link(from: from, to: to, strength: strength, dist: distance, transparent: transparent, halfway: halfway)) == nil else {
            return
        }
        deg[from] = (deg[from] ?? 0) + 1
        deg[to] = (deg[to] ?? 0) + 1
    }
    
    public func unlink(from: T, to: T) {
        // FIXME: traverse
        var found: Link<T>? = nil
        for l in links {
            if l.from.hashValue == from.hashValue && l.to.hashValue == to.hashValue {
                found = l
                break
            }
        }
        guard found != nil else {
            print("Not found link")
            return
        }
        links.remove(found!)
        deg[from] = (deg[from] ?? 0) - 1
        deg[to] = (deg[to] ?? 0) - 1
    }
    
    public func arrow(from nodes: inout Set<T>) -> CGPath {
        let path = CGMutablePath()
        //let offset = CGPoint(x: distance * 0.15, y: distance * 0.15)
        for l in links {
            // if it is transparent
            if l.transparent {
                continue
            }
            guard let fromIndex = nodes.index(of: l.from), let toIndex = nodes.index(of: l.to) else {
                continue
            }

            let fromPos = nodes[fromIndex].position
            let toPos = nodes[toIndex].position
            
            // FIXME:
            if l.halfway {
                path.addLineWithSpacing(from: fromPos, to: toPos, spacing: 20)
            }
            else {
               path.addArrowLine(from: fromPos, to: toPos, spacing: 20)
            }
            
        }
        return path
    }
    
    // update all the position
    public func tick(alpha: CGFloat, nodes: inout Set<T>) {
        for link in links {
            link.tick(alpha: alpha, degrees: deg, distance: distance, nodes: &nodes)
        }
    }
    
}

/* Links */
// a link between two
fileprivate struct Link<T: Node>: Hashable, Equatable {
    typealias Degrees = Dictionary<T, UInt>
    let from: T
    let to: T
    let strength: CGFloat?
    let dist: CGFloat?
    var transparent: Bool = false
    var halfway: Bool = false
    
    var hashValue: Int {
        return from.hashValue ^ to.hashValue
    }
    
    init(from: T, to: T, strength: CGFloat? = nil, dist: CGFloat? = nil, transparent: Bool = false, halfway: Bool = false) {
        self.from = from
        self.to = to
        self.strength = strength
        self.dist = dist
        self.transparent = transparent
        self.halfway = halfway
    }
    
    public func tick(alpha: CGFloat, degrees: Degrees, distance: CGFloat, nodes: inout Set<T>) {
        guard let fromIndex = nodes.index(of: from), let toIndex = nodes.index(of: to) else {
            return
        }
        
        var fromNode = nodes[fromIndex]
        var toNode = nodes[toIndex]
        
        let fromDegree = CGFloat(degrees[from] ?? 0), toDegree = CGFloat(degrees[to] ?? 0)
        
        let bias = fromDegree / (fromDegree + toDegree)
        let d = (self.dist ?? distance)
        let s = (self.strength ?? 0.7 / CGFloat(min(fromDegree, toDegree)))
        
        let delta = (toNode.position + toNode.velocity - fromNode.position - fromNode.velocity).jiggled
        let magnitude = delta.magnitude
        let value = delta * ((magnitude - d) / magnitude) * alpha * s
        
        toNode.velocity -= (value * bias)
        fromNode.velocity += (value * (1 - bias))
        
        // update
        nodes.update(with: fromNode)
        nodes.update(with: toNode)
    }
    
    static func ==(lhs: Link<T>, rhs: Link<T>) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
    
}


