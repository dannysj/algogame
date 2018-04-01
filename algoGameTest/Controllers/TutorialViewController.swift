//
//  TutorialViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private var timer: Timer = Timer()
    private var codeType: CodeType!
    private var timeLimit: Double = 10
    private var currentTime: Double = 0
    private var circleProgress: CircularProgress!
    private var consoleHeight: CGFloat = 300.0
    private var codeVHeight: CGFloat = 100.0 {
        didSet {
            consoleHeight = codeVHeight + labelHeight + 30 + 45
        }
    }
    private var labelHeight: CGFloat = 0 {
        didSet {
            consoleHeight = codeVHeight + labelHeight + 30 + 30
        }
    }
    private lazy var consoleView: ConsoleView = {
        let c = ConsoleView()
        
        c.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: consoleHeight)
        c.center = self.view.center
        return c
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeTitleFont()
        l.textColor = UIColor.white
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var bot: HexagonBot = {
        let b = HexagonBot()
        b.bounds = CGRect(x: 0, y: 0, width: 40, height: 50)
        b.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(b)
        return b
    }()
    
    // button
    let buttonSideLength:CGFloat = 80
    
    private lazy var okButton: FlatButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: buttonSideLength, height: buttonSideLength)
        let button = FlatButton(frame: buttonRect)
        button.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 30 - buttonSideLength / 2.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var xButton: FlatButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: buttonSideLength, height: buttonSideLength)
        let button = FlatButton(frame: buttonRect)
        button.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 30 - buttonSideLength / 2.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var codeVisualizer: CodeVisualizer = {
        let v = CodeVisualizer()
        v.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: codeVHeight)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // button
    private lazy var infoButton: FlatButton = {
        let length = buttonSideLength
        let buttonRect = CGRect(x: 0, y: 0, width: length, height: length)
        let button = FlatButton(frame: buttonRect)
        button.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 30 - length / 2.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // for transition
    let transition = BotFadeTransition()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activateTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.backgroundColor()
        // Do any additional setup after loading the view.
        // set code type
        
        codeType = CodeType.trace2
        
       
        showScreen()
    }
    
    deinit {
        if timer.isValid {
            timer.invalidate()
        }
    }
    func initCodeType(type: CodeType) {
        self.codeType = type
        
    }
    
    func showScreen() {
                labelHeight = codeType.name.heightForString(font: Theme.codeTitleFont(), width: self.view.bounds.width - 60 * 2)
        codeVHeight = codeType.code.joined(separator: "\n").heightForString(font: Theme.codeFont(), width: self.view.bounds.width - 60 * 2)
        print("Code V Height is \(codeVHeight)")
        self.view.addSubview(consoleView)

        
        self.view.insertSubview(bot, belowSubview: consoleView)
        NSLayoutConstraint.activate([
            bot.widthAnchor.constraint(equalToConstant: 80),
            bot.heightAnchor.constraint(equalToConstant: 100),
            bot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bot.centerYAnchor.constraint(equalTo: consoleView.topAnchor, constant: -15)
            ])
        
        consoleView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: consoleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: consoleView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: consoleView.topAnchor, constant: 35),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            ])
        
        titleLabel.text = codeType.name
        
        // code visualizer
        consoleView.addSubview(codeVisualizer)
        NSLayoutConstraint.activate([
            codeVisualizer.leadingAnchor.constraint(equalTo: consoleView.leadingAnchor),
            codeVisualizer.trailingAnchor.constraint(equalTo: consoleView.trailingAnchor),
            
            codeVisualizer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
            ])
        
        codeVisualizer.initCodeType(type: codeType)
        
        addOkButton()
        addInfoButton()
        test()
    }
    
    func moreInfo() {
        // remove all stuffs,
    }
    
    func activateTimer() {
        if timer.isValid {
            print("Timer is valid")
            timer.invalidate()
        }
        currentTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        print("Activated timer")
        circleProgress.animate(toValue: timeLimit)
    }
    
    @objc func timerRunning() {
        currentTime += 1
        if currentTime == timeLimit {
            okButtonTapped()
        }
    }
    private func addOkButton() {
        self.view.addSubview(okButton)
        
        NSLayoutConstraint.activate([
            okButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            okButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            okButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            okButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
        
        okButton.initType(type: .Ok)
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(okButtonTapped))
        okButton.addGestureRecognizer(buttonTap)
        
        // some timer
        circleProgress = CircularProgress()
        
        view.layer.addSublayer(circleProgress)
        circleProgress.initialize(point: okButton.center, radius: (buttonSideLength + 15) / 2, lineWidth: 4)
    }
    
    @objc func okButtonTapped() {
        var gameVC: UIViewController? = nil
        switch codeType {
            case .dfslexi:
                let vc = GraphViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            case .dfsnonlexi:
                let vc = GraphViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            case .bfs:
                let vc = GraphViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            case .dijkstra:
                let vc = GraphViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            case .trace1:
                let vc = TracerViewController()
                //let vc = ViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            case .trace2:
                let vc = TracerViewController()
                //let vc = ViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            case .quickSort:
                let vc = BarViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            case .insertionSort:
                let vc = BarViewController()
                vc.initCodeType(type: codeType)
                gameVC = vc
            
        default:
            fatalError("Error in generating codeType")
        }
        if let gotoVC = gameVC {
            gotoVC.transitioningDelegate = self
            gotoVC.modalPresentationStyle = .custom
            self.present(gotoVC, animated: true, completion: nil)
        }

    }
    
    private func addInfoButton() {
        self.view.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            infoButton.leadingAnchor.constraint(equalTo: bot.trailingAnchor, constant: 15),
            infoButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            infoButton.widthAnchor.constraint(equalToConstant: buttonSideLength ),
            infoButton.bottomAnchor.constraint(equalTo: bot.topAnchor, constant: -5)
            ])
        
        infoButton.initType(type: .Info)
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(infoButtonTapped))
        infoButton.addGestureRecognizer(buttonTap)
    }
    
    private func addXButton() {
        self.view.addSubview(xButton)
        
        NSLayoutConstraint.activate([
            xButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            xButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            xButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            xButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
        
        xButton.initType(type: .Close)
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(xButtonTapped))
        xButton.addGestureRecognizer(buttonTap)
        
    }
    
    
    @objc func xButtonTapped() {
        
    }
    
    @objc func infoButtonTapped() {
        print("Info button tapped")
        if timer.isValid {
            timer.invalidate()
            self.circleProgress.removeAllAnimations()
        }
        
        /*
        let center = consoleView.center
        let moveY = self.view.bounds.height * 0.2
        UIView.animate(withDuration: 0.5, animations: {
            self.infoButton.alpha = 0
            self.okButton.alpha = 0
            self.circleProgress.opacity = 0
        }) { (_) in
            self.infoButton.removeFromSuperview()
            self.okButton.removeFromSuperview()
            self.circleProgress.removeFromSuperlayer()
            self.xButton.alpha = 0
            self.addXButton()
            UIView.animate(withDuration: 0.5, animations: {
                self.consoleView.center = CGPoint(x: center.x, y: center.y + moveY)
                self.xButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { _ in
                
            }
        }
*/
    }
    
    func test () {
   
        let centerY: CGFloat = bot.center.y - 100
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: [.repeat, .curveEaseInOut, .autoreverse], animations: {
            self.bot.center = CGPoint(x: self.bot.center.x, y: centerY)
        }) { (_) in
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let gameVC = segue.destination as! GraphViewController
        gameVC.transitioningDelegate = self
        gameVC.modalPresentationStyle = .custom
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


