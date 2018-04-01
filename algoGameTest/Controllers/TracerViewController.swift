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
    private lazy var timer: Timer = {
        let t = Timer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        // scheduledTimer(timeInterval: 1, target: self, selector: , userInfo: nil, repeats: true)
        return t
    }()
    private var timeLimit: Int = 5
    private var currentTime: Int = 0
    private var currentScore: Int = 0 {
        didSet {
            main.async {
                self.gameLabel.text = "\(self.currentScore)"
            }
        }
    }
    private lazy var plusScoreView: ScoreArithmeticHUD = {
        let b = ScoreArithmeticHUD()
        b.bounds = CGRect(x: 0, y: 0, width: 60, height: 50)
        //b.translatesAutoresizingMaskIntoConstraints = false
        //b.alpha = 0
        
        self.view.addSubview(b)
        return b
    }()
    private var height: CGFloat = UIScreen.main.bounds.height * 0.4
    private var codeVHeight: CGFloat = 0
    private lazy var console: OutputTracer = {
        let consoleSize = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: height)
        let c = OutputTracer(frame: consoleSize)
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    private let main = DispatchQueue.main
    private let global = DispatchQueue.global()
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
        l.font = Theme.scoreFont()
        l.textAlignment = .center
        l.textColor = Theme.lineColor()
        l.center = CGPoint(x: self.view.center.x, y: 20 + 30)
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
            main.async {
                self.nLabel.text = "n = \(self.n)"
            }
            
        }
    }
    
    private var circleProgress: CircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        codeVHeight = UIScreen.main.bounds.height - height - buttonSideLength - 60
        self.view.backgroundColor = Theme.backgroundColor()
        
    }
    

    
    func initCodeType(type: CodeType, score: Int) {
        self.codeType = type
        self.currentScore = score
        setupScreen()
    }
    
    func activateTimer() {

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        print("Activated timer")
        
        circleProgress.animate(toValue: Double(timeLimit))
    }
    
    @objc func timerRunning() {
        currentTime += 1
        print("Called")
        if (currentTime % timeLimit == 0) {
            print("5 seconds")
            if isLeaky {
                let statusVC = StatusViewController()
                statusVC.updateStatus(status: .Failed, score: currentScore)
                self.present(statusVC, animated: false, completion: nil)
                
            } else {
                // continue, add marks
                currentScore += 5
                plusScoreView.updateScore(score: currentScore)
                isLeaky = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        main.asyncAfter(deadline: .now() + 2.5) {
            self.runAlgorithm()
            self.activateTimer()
            self.codeVisualizer.showScroll()
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
            console.topAnchor.constraint(equalTo: self.gameLabel.bottomAnchor, constant: 15)
            ])
        addButton()
        self.view.addSubview(codeVisualizer)
        NSLayoutConstraint.activate([
            codeVisualizer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            codeVisualizer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            codeVisualizer.topAnchor.constraint(equalTo: console.bottomAnchor, constant: 15),
            //codeVisualizer.heightAnchor.constraint(equalToConstant: codeVHeight),
            codeVisualizer.bottomAnchor.constraint(equalTo: self.flatButton.topAnchor, constant: -15)
            ])
        
        print(codeType.name)
        codeVisualizer.initCodeType(type: codeType, withScrollableWindow: true
        )
        
        self.view.addSubview(nLabel)
        NSLayoutConstraint.activate([
            nLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45),
            nLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            nLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
            ])
        
        
        
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
       // activateTimer()
        if isLeaky {
            // add marks + leave
            currentScore += 5
            gotoHeaven()
        }
        else {
            // lose game
           // timer.invalidate()
            gotoHell()
        }
    }
    
    func gotoHeaven() {
        timer.invalidate()
        let statusVC = StatusViewController()
        statusVC.updateStatus(status: .Pass, score: currentScore)
        
        self.present(statusVC, animated: false, completion: nil)
    }
    
    func gotoHell() {
      //  if timer.isValid {
            timer.invalidate()
       // }
        let statusVC = StatusViewController()
        statusVC.updateStatus(status: .Failed, score: currentScore)
        
        self.present(statusVC, animated: false, completion: nil)
    }
    
    
    func leakyTracingAlgorithm1() {
        n = random(min: 3, max: 8)
        for i in 1 ..< n+1 {
            var j = n
            var str = ""
            if !leakyOrNot() {
                while ( j > i) {
                
                    str += " "
                    j -= 1
                }
            }
            
            while ( j >= 0) {
                    if !leakyOrNot() {
                    str += "*"
                    j -= 1
                }
            }
            //print(str)
            main.sync {
                console.addOutputLine(str: str)
            }
            sleep(1)
            
        }
    }
    
    func leakyTracingAlgorithm2() {
        n = random(min: 8, max: 12)
        
        var k: Int = 0
        for i in 1 ..< n+1 {
            var str = ""
            for _ in 1 ..< (n - i) + 1 {
                if !leakyOrNot() {
                str += " "
                }
            }
            
            for _ in 0 ..< i {
                if !leakyOrNot() {
                str += "* "
                }
            }
            
            print(str)
            main.sync {
                console.addOutputLine(str: str)
            }
            sleep(1)
            
        }
        k = 1
   
        for i in stride(from: n,to: 0, by: -1) {
            var str = ""
            if !leakyOrNot() {
            for _ in 1 ..< k {
                
                str += " "
                }
            }
            k += 1
            
            for _ in 0 ..< i {
                if !leakyOrNot() {
                str += "* "
                }
            }
            
            print(str)
            main.sync {
                console.addOutputLine(str: str)
            }
            sleep(1)
        }
    }

    func runAlgorithm() {
        print("Run called")
        
        global.async {
            if self.codeType == .trace1 {
                self.leakyTracingAlgorithm1()
            }
            else {
                self.leakyTracingAlgorithm2()
            }
            
           self.gotoHeavenWithoutFailing()
        }
       
        
    }
    func gotoHeavenWithoutFailing() {
        timer.invalidate()
        let statusVC = StatusViewController()
        statusVC.updateStatus(status: .PassWithoutError, score: currentScore)
        
        self.present(statusVC, animated: false, completion: nil)
    }
    
    func leakyOrNot() -> Bool {
        // one leaky at a time
        if isLeaky {
            return false
        }
        let x =  arc4random_uniform(6) == 1
        if x {
            isLeaky = true
        }
        return x
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
