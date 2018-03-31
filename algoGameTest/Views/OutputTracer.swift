//
//  OutputTracer.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/27/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation
import UIKit

class OutputTracer: UIView {
    private lazy var consoleView: ConsoleView = {
        let c = ConsoleView()
        //c.center = self.center
        c.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        return c
    }()
// leaky
    private var lines: [String] = [] {
        didSet {
            updateOutput()
        }
    }

    private lazy var outputLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeFont()
        l.textColor = UIColor.white
        l.numberOfLines = 0
        return l
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        initFrame()
    }
    
    func initFrame() {
        consoleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(consoleView)
        
        NSLayoutConstraint.activate([
            consoleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            consoleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            consoleView.heightAnchor.constraint(equalTo: self.heightAnchor),
            consoleView.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        
        addSubview(outputLabel)
        NSLayoutConstraint.activate([
            outputLabel.leadingAnchor.constraint(equalTo: consoleView.leadingAnchor, constant: 15),
            outputLabel.trailingAnchor.constraint(equalTo: consoleView.trailingAnchor, constant: -15),
            outputLabel.topAnchor.constraint(equalTo: consoleView.topAnchor, constant: 15),
            outputLabel.bottomAnchor.constraint(equalTo: consoleView.bottomAnchor, constant: -15)
            ])
        
    }
    
    func addOutputLine(str: String) {
        lines.append(str)
    }
    
    func updateOutput() {
        var str = ""
        for i in 0 ..< lines.count {
            str += "\(i+1)  \(lines[i])\n"
            outputLabel.text = str
            sleep(1)
        }
    }
    
}
