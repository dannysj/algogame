//
//  ViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/26/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let buttonSideLength:CGFloat = 80
    private var transition: BotFadeTransition = BotFadeTransition()
    private lazy var flatButton: FlatButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: buttonSideLength, height: buttonSideLength)
        let button = FlatButton(frame: buttonRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var console: ConsoleView = {
        let c = ConsoleView()
       
        c.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 250)
         c.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 300)
        return c
    }()
    
    private lazy var bot: HexagonBot = {
        let b = HexagonBot()
        b.bounds = CGRect(x: 0, y: 0, width: 80, height: 100)
        //b.translatesAutoresizingMaskIntoConstraints = false
        
        return b
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeLargerFont()
        l.textColor = UIColor.white
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeFont()
        l.textColor = UIColor.white
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    private var codeVHeight: CGFloat = 150
    private lazy var codeVisualizer: CodeVisualizer = {
        let v = CodeVisualizer()
        v.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: codeVHeight)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var str: [String] = [
        "Hi, I'm AlgoBot!",
        "I'm a compiler that turns your code into something magical!",
        "Sounds cool, right?",
        "Now, I need your help to check my progress.",
        "You'll be given the algorithm of the code...",
        "And I'll run and visualize it.",
        "Sometimes I can be a little bit clumsy.",
        "So if you saw something wrong with my execution, hit the ! button within the time limit!",
        "It will wake me up!",
        "Sounds easy right?\n Without further ado, let's get started :D"
        
    ]
    
    private var delay: [(Int, Int)] = [
    (1,2),(2,5), (2,2), (2,5), (2,7), (2,5), (2,4), (2,8), (2,4), (2,5)
    ]
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startIntro()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0x17264B)
        // Do any additional setup after loading the view, typically from a nib.
        setupScreen()
    }
    

    
    func setupScreen() {
        self.view.addSubview(bot)
        
        NSLayoutConstraint.activate([
            bot.widthAnchor.constraint(equalToConstant: 80),
            bot.heightAnchor.constraint(equalToConstant: 100),
           // bot.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        
        print(self.view.bounds)
        bot.center = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleLabel.bottomAnchor.constraint(equalTo: bot.topAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
            ])
        titleLabel.alpha = 0
        
        self.view.addSubview(console)

        
        console.alpha = 0
        
        console.addSubview(codeVisualizer)
        NSLayoutConstraint.activate([
            codeVisualizer.leadingAnchor.constraint(equalTo: console.leadingAnchor),
            codeVisualizer.trailingAnchor.constraint(equalTo: console.trailingAnchor),
            
            codeVisualizer.topAnchor.constraint(equalTo: console.topAnchor, constant: 20)
            ])
        
        codeVisualizer.initCodeType(type: .trace1)
        addButton()
        
        self.view.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            subTitleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        subTitleLabel.alpha = 0
        subTitleLabel.text = "Tap anywhere to skip"
        
        
    }
    func addSkipCommand() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(skip))
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func skip() {
        let gotoVC = TutorialViewController()
        gotoVC.initCodeType(type: .trace1)
        gotoVC.transitioningDelegate = self
        gotoVC.modalPresentationStyle = .custom
        self.present(gotoVC, animated: true, completion: nil)
    }
    
    private func addButton() {
        self.view.addSubview(flatButton)
        
        NSLayoutConstraint.activate([
            flatButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flatButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -30)
            ])
        
        flatButton.initType(type: .Alert)
        
        flatButton.alpha = 0
    }
    
    
    func startIntro() {
        let newCenterX = self.bot.center.x
        let newCenterY = self.bot.center.y + 200
        
        let newCCenterX = self.console.center.x
        let newCCenterY = self.console.center.y + 200
        
        self.console.center = CGPoint(x: newCCenterX, y: newCCenterY)
        
        DispatchQueue.global().async {
            for i in 0 ..< self.str.count {
                let s = self.str[i]
                
                DispatchQueue.main.sync {
                    self.titleLabel.text = s
                    UIView.animate(withDuration: 0.5, delay: TimeInterval(self.delay[i].0), options: [], animations: {
                        self.titleLabel.alpha = 1

                        if i == 4 {
                            self.bot.center = CGPoint(x: newCenterX, y: newCenterY)
                            self.console.alpha = 1
                            self.view.layoutIfNeeded()
                        }
                        if i == 7 {
                            self.flatButton.alpha = 1
                        }
                    }) { (_) in
                        if i == 7 || i == 8 {
                            self.flatButton.animate()
                        }
                        UIView.animate(withDuration: 0.5, delay: TimeInterval(self.delay[i].1), options: [], animations: {
                            if i == 0 {
                                self.subTitleLabel.alpha = 1
                            }
                            self.titleLabel.alpha = 0
                            if i == 5 {
                                self.console.alpha = 0
                                
                            }
                            if i == 8 {
                                self.flatButton.alpha = 0
                                self.bot.center = self.view.center
                                self.view.layoutIfNeeded()
                            }
                        }, completion: { (_) in
                            if i == 5 {
                                self.console.removeFromSuperview()
                            }
                            if i == 0 {
                                self.addSkipCommand()
                            }
                            //self.console.removeFromSuperview()
                        })
                    }
                }
                let d = self.delay[i].0 + self.delay[i].1 + 1
                sleep(UInt32(d))
                
            }
            DispatchQueue.main.sync {
                // Do smth:
                let gotoVC = TutorialViewController()
                gotoVC.initCodeType(type: .trace1)
                gotoVC.transitioningDelegate = self
                gotoVC.modalPresentationStyle = .custom
                self.present(gotoVC, animated: true, completion: nil)
            }
        }


    }

    
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

