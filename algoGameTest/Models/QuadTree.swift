//
//  QuadTree.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/28/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//  reference: Wikipedia + Conrad's Quadd Tree

import Foundation
import CoreGraphics


/*
 _________________
 |   NW   |   NE
 |        |
 |        |
 |        |
 |________|______
 |        |
 |   SW   |  SE
 |        |
 |_______________
 */
public enum QuadTree<T> {
    // leaf
    case Leaf(CGPoint, T)
    //                          NW          NE      SW          SW
    indirect case Box(CGRect, QuadTree?, QuadTree?, QuadTree? , QuadTree? , T)
    

    
    var bounds: CGRect {
        switch self {
        case let .Leaf(pos, _):
            // form new rect, as
            return CGRect(origin: pos, size: .zero)
        case let .Box(bounds, _,_,_,_,_):
            // just return the boundingbox
            return bounds
        }
    }
    
    var leaf: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
    
    var value: T {
        switch self {
        case let .Leaf(_, val):
            // form new rect, as
            return val
        case let .Box(_, _,_,_,_,val):
            // just return the val
            return val
        }
    }
    
    // leaf
    init?<U: Node, V: Collection>(nodes: V, initial: (U) -> T, accumulator: ([QuadTree<T>?]) -> T ) where V.Iterator.Element == U {
        //find the bounding rect for all nodes and form a rect for it.
        guard let rect = nodes.map({$0.position}).boundingRect else {
            return nil
        }
        self.init(nodes: nodes, rect: rect, initial: initial, accumulator: accumulator)
    }
    
    // init when there's a need to divide into Boxes
    init?<U: Node, V: Collection>(nodes: V, rect: CGRect, initial: (U) -> T, accumulator: ([QuadTree<T>?]) -> T ) where V.Iterator.Element == U {
        // particles count = 0? Nope
        guard nodes.count > 0 else {
            return nil
        }
        
        let count = nodes.count
        // if there's only one, then just one leaf
        if let node = nodes.first, count == 1 {
            self = .Leaf(node.position, initial(node))
        }
        else {
            let height = rect.height / 2.0
            let width = rect.width / 2.0
            
            // coordinates of the cgrect
            // origin
            let oX = rect.minX
            let oY = rect.minY
            // mid
            let mX = rect.midX
            let mY = rect.midY
            
            // bounding boxes
            let northWest = CGRect(x: oX, y: oY, width: width, height: height)
            let northEast = CGRect(x: mX, y: oY, width: width, height: height)
            let southWest = CGRect(x: oX, y: mY, width: width, height: height)
            let southEast = CGRect(x: mX, y: mY, width: width, height: height)
            
            var nwNodes: [U] = [], neNodes:[U] = [], swNodes: [U] = [], seNodes: [U] = []
            
            for n in nodes {
                let pos = n.position
                
                if northWest.contains(pos) {
                    nwNodes.append(n)
                }
                
                else if northEast.contains(pos) {
                    neNodes.append(n)
                }
                
                else if southWest.contains(pos) {
                    swNodes.append(n)
                }
                else if southEast.contains(pos) {
                    seNodes.append(n)
                }
                
            }
            
            // 4 sub trees
            let nwTree = QuadTree(nodes: nwNodes, rect: northWest, initial: initial, accumulator: accumulator)
            let neTree = QuadTree(nodes: neNodes, rect: northEast, initial: initial, accumulator: accumulator)
            let swTree = QuadTree(nodes: swNodes, rect: southWest, initial: initial, accumulator: accumulator)
            let seTree = QuadTree(nodes: seNodes, rect: southEast, initial: initial, accumulator: accumulator)
            
            let val = accumulator([nwTree,neTree,swTree,seTree])
            self = .Box(rect, nwTree, neTree, swTree, seTree, val)
        }
        
    }
    // FIXME:
    func visit(_ f: (QuadTree<T>) -> Bool ) {
        if f(self) {
            return
        }
        
        if case let .Box(_,a,b,c,d, _) = self {
            a?.visit(f)
            b?.visit(f)
            c?.visit(f)
            d?.visit(f)
        }
        
    }
}
