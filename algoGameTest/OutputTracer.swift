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
        c.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
// leaky

    override func layoutSubviews() {
        super.layoutSubviews()
        initFrame()
    }
    
    func initFrame() {
        addSubview(consoleView)
        consoleView.initFrame()
        
        
    }
    
}
