//
//  GraphDrawing.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/28/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
import UIKit
class GraphDrawing<T: Hashable>: UIView {
    private var graph: AdjacencyListGraph<T>? = nil
    private var pRadius: CGFloat = 0
    private var arrowLength: CGFloat = 0
    private let pRatio: CGFloat = 0.4
    private let aRatio: CGFloat = 0.6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupGraph(graph: AdjacencyListGraph<T>) {
        self.graph = graph
        drawGraph()
    }
    
    private func drawGraph() {
        if let v = graph {
            let s = v.topologicalSort()
            let nodeCount = s.count
            
        }
    }
    
    private func randomLayoutGenerator(_ num: Int) -> [Int] {
        var a = [1]
        var nodesCount = num - 1
        
        while nodesCount > 0 {
            if nodesCount <= 4 {
                a.append(nodesCount)
                break
            }
            
            // then we generate
            let x = random(min: 2, max: 5)
            a.append(x)
            nodesCount -= x
            
        }
        
        return a
    }
}
