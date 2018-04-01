//
//  ScoreArithmeticHUD.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class ScoreArithmeticHUD: UIView {
    private lazy var updateLabel: UILabel = {
       let u = UILabel()
        u.translatesAutoresizingMaskIntoConstraints = false
        u.textColor = UIColor.FlatColor.Yellow.sunflowerLight
        u.textAlignment = .center
        u.font = Theme.codeFont()
        u.alpha = 0
        return u
    }()
    
    private var score: Int = 0 {
        didSet {
            if score > 0 {
                updateLabel.text = "++ \(score) !"
            }
            else {
                updateLabel.text = "-- \(abs(score)) !"
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initFrame()
    }
    
    func initFrame() {
        self.addSubview(updateLabel)
        NSLayoutConstraint.activate([
            updateLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            updateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            updateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            updateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
    func updateScore(score: Int) {
        self.score = score
        let currentCenter = self.center
        self.center = CGPoint(x: currentCenter.x, y: currentCenter.y - 10)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.center = CGPoint(x: currentCenter.x, y: currentCenter.y + 10)
            self.updateLabel.alpha = 1.0
        }) {
            bool in
            UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.updateLabel.alpha = 0.0
            }) { bool in
                self.center = currentCenter
            }
        }
    }

}
