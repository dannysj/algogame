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
    private lazy var codeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeFont()
        l.textColor = UIColor.white
        l.numberOfLines = 0
        return l
    }()
    
    func initCodeType(type: CodeType) {
        self.type = type
        initWindow()
    }
    
    func initWindow() {
        self.addSubview(codeLabel)
        NSLayoutConstraint.activate([
            codeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            codeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            codeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
            ])
        
        codeLabel.text = type.code.joined(separator: "\n")
    }
    
    func showArrow() {
        
    }
    

}

enum CodeType {
    case dfslexi
    case dfsnonlexi
    case bfs
    case dijkstra
    case trace1
    case trace2
    case quickSort
    case insertionSort

    var code: [String] {
        switch self {
        case .dfslexi:
            return CodeString.dfslexi()
        case .dfsnonlexi:
            return CodeString.dfsnonlexi()
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
    
    var name: String {
        switch self {
        case .dfslexi:
            return "Depth First Search (Lexi-)"
        case .dfsnonlexi:
            return "Depth First Search (Non-Lexi)"
        case .bfs:
            return "Breadth First Search"
        case .dijkstra:
            return "Dijkstra's Algorithm"
        case .trace2:
            return "Tracing Time!"
        case .trace1:
            return "Tracing Time!"
        case .quickSort:
            return "Quick Sort"
        case .insertionSort:
            return "Insertion Sort"
            
        }
    }
}
