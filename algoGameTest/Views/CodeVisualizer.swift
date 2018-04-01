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
    private lazy var consoleView: ConsoleView = {
        let c = ConsoleView()
        //c.center = self.center
        c.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        return c
    }()
    
    private lazy var codeScrollableView: UITextView = {
        let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = Theme.codeFont()
        v.textColor = UIColor.white
        v.isEditable = false
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    
    private var withScrollableWindow: Bool = false
    
    func initCodeType(type: CodeType, withScrollableWindow:Bool  = false) {
        self.type = type
        self.withScrollableWindow = withScrollableWindow
        if withScrollableWindow {
            initConsole()
        } else {
           initWindow()
        }
        
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
    
    func initConsole() {
        consoleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(consoleView)
        
        NSLayoutConstraint.activate([
            consoleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            consoleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            consoleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            consoleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        
        consoleView.addSubview(codeScrollableView)
        NSLayoutConstraint.activate([
            codeScrollableView.leadingAnchor.constraint(equalTo: consoleView.leadingAnchor, constant: 15),
            codeScrollableView.trailingAnchor.constraint(equalTo: consoleView.trailingAnchor, constant: -15),
            codeScrollableView.topAnchor.constraint(equalTo: consoleView.topAnchor, constant: 20),
            codeScrollableView.bottomAnchor.constraint(equalTo: consoleView.bottomAnchor, constant: -15)
            ])
        //outputLabel.backgroundColor = UIColor.red
        codeScrollableView.text = type.code.joined(separator: "\n")
        
    }
    
    func showArrow() {
        
    }
    
    func showScroll() {
        if withScrollableWindow {
            codeScrollableView.flashScrollIndicators()
        }
    }

}

enum CodeType: UInt32 {
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
    
    private static let _count: CodeType.RawValue = {
        var maxValue: UInt32 = 0
        while let _ = CodeType(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()
    
    
    static func randomCode() -> CodeType {
        // pick and return one
        let rand = arc4random_uniform(_count)
        return CodeType(rawValue: rand)!
    }
}
