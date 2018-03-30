//
//  CodeVisualizer.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class CodeVisualizer: UIView {

    private var type: CodeType!
    
    func initCodeType(type: CodeType) {
        self.type = type
        initWindow()
    }
    
    func initWindow() {
        
    }
    
    func showArrow() {
        
    }
    

}

enum CodeType {
    case dfs
    case bfs
    case dijkstra
    case trace1
    case trace2
    case quickSort
    case insertionSort

    var code: String {
        switch self {
        case .dfs:
            return CodeString.dfs()
        case .bfs:
            return CodeString.bfs()
        case .dijkstra:
            return CodeString.dijkstra()
        case .trace2:
            return CodeString.trace2()
        case .trace1:
            return CodeString.trace1()
        case .quickSort:
            return CodeString.quickSort()
        case .insertionSort:
            return CodeString.insertionSort()

        }
    }
}
