//
//  TracerViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/31/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class TracerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    // for transition
    let transition = BotFadeTransition()
    private var timer: Timer = Timer()
    private var timeLimit: Double = 10
    private var currentTime: Double = 0
    private var height: CGFloat = UIScreen.main.bounds.height * 0.4
    private var codeVHeight: CGFloat = 0
    private lazy var console: OutputTracer = {
        let consoleSize = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: height)
        let c = OutputTracer(frame: consoleSize)
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    private lazy var codeVisualizer: CodeVisualizer = {
        let v = CodeVisualizer()
        v.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: codeVHeight)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // button
    let buttonSideLength:CGFloat = 80
    private lazy var flatButton: FlatButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: buttonSideLength, height: buttonSideLength)
        let button = FlatButton(frame: buttonRect)
        button.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 30 - buttonSideLength / 2.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var gameLabel: UILabel = {
        let l = UILabel()
        l.text = "-"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeTitleFont()
        l.textAlignment = .center
        l.textColor = Theme.lineColor()
        return l
    }()
    
    private lazy var nLabel: UILabel = {
        let l = UILabel()
        l.text = "-"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeLargerFont()
        l.textAlignment = .right
        l.textColor = Theme.lineColor()
        return l
    }()
    
    private var codeType: CodeType!
    private var isLeaky: Bool = false
    private var n:Int = 0 {
        didSet {
            nLabel.text = "n = \(n)"
        }
    }
    
    private var circleProgress: CircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        codeVHeight = UIScreen.main.bounds.height - height - buttonSideLength - 60
        self.view.backgroundColor = Theme.backgroundColor()
        setupScreen()
    }
    
    func initCodeType(type: CodeType) {
        self.codeType = type
    }
    

    func activateTimer() {
        if timer.isValid {
            print("Timer is valid")
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        print("Activated timer")
        circleProgress.animate(toValue: timeLimit)
    }
    
    @objc func timerRunning() {
        currentTime += 1
        
        if (currentTime == timeLimit) {
            print("5 seconds")
            if isLeaky {
                let statusVC = StatusViewController()
                statusVC.updateStatus(status: .Failed)
                self.present(statusVC, animated: false, completion: nil)
                
            }
        }
    }
    
    func setupScreen() {
        self.view.addSubview(gameLabel)
        NSLayoutConstraint.activate([
            gameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45),
            gameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            gameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
            ])
        
        self.view.addSubview(console)
        
        NSLayoutConstraint.activate([
            console.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            console.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            console.heightAnchor.constraint(equalToConstant: height),
            console.topAnchor.constraint(equalTo: self.gameLabel.bottomAnchor, constant: 30)
            ])
        
        self.view.addSubview(codeVisualizer)
        NSLayoutConstraint.activate([
            codeVisualizer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            codeVisualizer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            codeVisualizer.topAnchor.constraint(equalTo: console.bottomAnchor, constant: 15),
            codeVisualizer.heightAnchor.constraint(equalToConstant: codeVHeight)
            ])
        
        codeVisualizer.initCodeType(type: codeType)
        
        self.view.addSubview(nLabel)
        NSLayoutConstraint.activate([
            nLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45),
            nLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            nLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
            ])
        
        addButton()
        
        circleProgress = CircularProgress()
        
        view.layer.addSublayer(circleProgress)
        circleProgress.initialize(point: flatButton.center, radius: (buttonSideLength + 15) / 2, lineWidth: 4)
        
        

    }
    
    private func addButton() {
        self.view.addSubview(flatButton)
        
        NSLayoutConstraint.activate([
            flatButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flatButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
        
        flatButton.initType(type: .Alert)
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        flatButton.addGestureRecognizer(buttonTap)
    }
    
    @objc func buttonTapped() {
        activateTimer()
        if isLeaky {
            // add marks
        }
        else {
            // lose game
            //timer.invalidate()
        }
    }
    
    func leakyTracingAlgorithm1() {
        n = random(min: 5, max: 8)
        for i in 1 ..< n+1 {
            var j = n
            var str = ""
            while ( j > i) {
                str += " "
                j -= 1
            }
            while ( j >= 0) {
                str += "*"
                j -= 1
            }
            print(str)
            
        }
    }
    
    func leakyTracingAlgorithm2() {
        n = random(min: 5, max: 8)
        
        var k: Int = 0
        for i in 1 ..< n+1 {
            var str = ""
            for _ in 1 ..< (n - i) + 1 {
                str += " "
            }
            
            for _ in 0 ..< i {
                str += "* "
                
            }
            
            print(str)
            
        }
        k = 1
   
        for i in stride(from: n,to: 0, by: -1) {
            var str = ""
            for _ in 1 ..< k {
                str += " "
            }
            k += 1
            
            for _ in 0 ..< i {
                str += "* "
                
            }
            
            print(str)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //transition.mode = .dismiss
        transition.color = Theme.backgroundColor()
        
        return transition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //transition.mode = .present
        transition.color = Theme.backgroundColor()
        
        return transition
    }

}
