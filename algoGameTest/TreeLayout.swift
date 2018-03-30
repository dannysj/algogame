//
//  TreeLayout.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/27/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
import CoreGraphics

// Traverse Strategy
public protocol TraversalStrategy {
    static func traversalSequence<Node: Tree>(_ rootNode: Node) -> AnySequence<Node>
}

// TraversableTree
public protocol TraversableTree: Tree, Sequence {
    var strategy: TraversalStrategy.Type? { get }
}

extension TraversableTree {
    public func makeIterator() -> AnyIterator<Self> {
        guard let strategy = strategy else {
            return AnyIterator { nil }
        }
        return strategy.traversalSequence(self).makeIterator()
    }
}

// Drawable Tree Layout model
protocol TreeLayoutTopology: TraversableTree {
    var gridUnitSize: CGFloat { get }
    var logicalX: Int { get set }
    var logicalY: Int { get set }
}

public final class TreeLayout<Node: Tree>: TreeLayoutTopology {
    
}
