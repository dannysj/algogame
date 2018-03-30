//
//  ForceDirectedGraph.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/29/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import CoreGraphics
import QuartzCore

public class ForceDirectedGraph<T: Node> {
    
    // a= alpha, v = velocity
    private let vDecayRate: CGFloat = 0.9
    private let aDecayRate: CGFloat = 1 - pow(0.001, 1 / 500)
    private let aTarget: CGFloat = 0
    private let aMin: CGFloat = 0.001
    
    private var alpha: CGFloat  = 1{
        didSet {
            if alpha < aMin {
                alpha = 0
            }
            displayLink?.isPaused = (alpha < aMin)
        }
    }
    
    private weak var displayLink: CADisplayLink?
    
    // nodes, forces, links update
    var nodes: Set<T> = []
    private var forces: [(CGFloat, inout Set<T>) -> Void] = []
    private var ticksAction: [(inout Set<T>) -> Void] = []
    
    // initializers
    
    public init() {
        
    }
    
    public init<U: Force>(manyNodes: U, system: U, center: U) where U.Subject == T {
        insertForce(manyNodes)
        insertForce(system)
        insertForce(center)
        //insertTick(tickToBeInsert)
    }
    
    public func insertForce<U: Force>(_ force: U) where U.Subject == T {
        forces.append(force.tick)
    }
    
    public func insertTick(_ tick: @escaping (inout Set<T>) -> Void) {
        ticksAction.append(tick)
    }
    
    public func insertNode(_ node: T) {
        nodes.insert(node)
    }
    
    public func removeNode(_ node: T) -> T {
        return nodes.remove(node)!
    }
    
    // display link functions
    public func start() {
        guard displayLink == nil else {
            return
        }
        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.add(to: .main, forMode: .commonModes)
        displayLink = link
    }
    
    public func testRun() {
        botReset()
        tick()
    }
    
    @objc public func tick() {
        alpha += (aTarget - alpha) * aDecayRate
        guard alpha > aMin else { return }

        // update manyNodex, system, center with
        for f in forces {
            f(alpha, &nodes)
        }
        
        for var n in nodes {
            // don't update if it is fixed nodes
            if !n.fixed {
                n.velocity *= vDecayRate
                n.position += n.velocity
            }
            else {
                n.velocity = .zero
            }
            nodes.update(with: n)

        }
        
        // update visual for nodes
        for n in nodes {
            n.tick()
        }
        
        // update links {
        for t in ticksAction {
            t(&nodes)
        }
        
        // finally, the bot's location
        
    }
    
    public func stop() {
        displayLink?.remove(from: .main, forMode: .commonModes)
    }
    
    public func reset() {
        alpha = 1.0
    }
    
    private func botReset() {
        alpha = 0.3
    }
    
}
