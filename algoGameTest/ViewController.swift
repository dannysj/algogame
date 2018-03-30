//
//  ViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/26/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    let buttonSideLength:CGFloat = 80
    private lazy var flatButton: FlatButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: buttonSideLength, height: buttonSideLength)
        let button = FlatButton(frame: buttonRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0x17264B)
        // Do any additional setup after loading the view, typically from a nib.
        let consoleSize = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 500)
        let console = ConsoleView(frame: consoleSize)
        console.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(console)
        
        NSLayoutConstraint.activate([
            console.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            console.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            console.heightAnchor.constraint(equalToConstant: consoleSize.height),
            console.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        
        console.initFrame()
        
        let bot = HexagonBot()
        bot.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bot)
        
        NSLayoutConstraint.activate([
            bot.widthAnchor.constraint(equalToConstant: 80),
            bot.heightAnchor.constraint(equalToConstant: 100),
            bot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bot.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

        
        let circle = CircularProgress()
        
        view.layer.addSublayer(circle)
        circle.initialize(point: self.view.center)

        circle.animate()
        

        self.view.addSubview(flatButton)
        
        NSLayoutConstraint.activate([
            flatButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flatButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])

        flatButton.initialize()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

