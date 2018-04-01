//
//  StatusViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/31/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

enum GameStatus {
    case Loading
    case Pass
    case Failed
    case PassWithoutError
}

class StatusViewController: UIViewController, UIViewControllerTransitioningDelegate {
    // for transition
    private lazy var timer: Timer = {
        let t = Timer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        // scheduledTimer(timeInterval: 1, target: self, selector: , userInfo: nil, repeats: true)
        return t
    }()
    let transition = BotFadeTransition()
    private var timeLimit: Int = 5
    private var currentTime: Int = 0
    private var status: GameStatus! {
        didSet {
            switch status {
            case .Loading:
                setupLoadingScreen()
            case .Pass:
                setupPassScreen()
            case .Failed:
                setupFailScreen()
            case .PassWithoutError:
                setupProceedScreen()
            default:
                fatalError("Shouldn't be here")
            }
        }
    }
    
    private lazy var circleProgress: CircularProgress = {
        let v = CircularProgress()
        
        return v
    }()
    
    private var score: Int = 0 {
        didSet {
            scoreLabel.text = "You scored \(score)"
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.scoreFont()
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
        l.numberOfLines = 0
         l.textAlignment = .center
        return l
    }()
    
    private lazy var scoreLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeLargerFont()
        l.textColor = UIColor.white
        l.numberOfLines = 0
         l.textAlignment = .center
        return l
    }()
    
    private lazy var buttonDesLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Theme.codeLargerFont()
        l.textColor = UIColor.white
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    // button
    let buttonSideLength:CGFloat = 80
    private lazy var flatButton: FlatButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: buttonSideLength, height: buttonSideLength)
        let button = FlatButton(frame: buttonRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 30 - buttonSideLength / 2.0)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if status != GameStatus.Failed {
            activateTimer()
        }
        
    }
    func updateScore(score: Int) {
        self.score = score
    }
    
    func updateStatus(status: GameStatus, score: Int = 0) {
        self.status = status
        self.score = score
    }
    
    func activateTimer() {
        currentTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        print("Activated timer")
        circleProgress.animate(toValue: Double(timeLimit))
    }
    
    @objc func timerRunning() {
        print("Status, current running")
        currentTime += 1
        if currentTime == timeLimit {
            proceedToNext()
        }
    }
    
    private func setupFailScreen() {
        self.view.backgroundColor = UIColor.FlatColor.Red.grapeFruitDark
        
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -45)
            ])
        
        titleLabel.center = self.view.center
        titleLabel.text = "Oops!"
        
        self.view.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0)
            ])
        
        subTitleLabel.text = "Better luck next time!"
        
        self.view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            scoreLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40)
            ])
        
        scoreLabel.text = "You scored \(self.score)"
        
        addCloseButton()
        
        // FIXME:
        self.view.addSubview(buttonDesLabel)
        NSLayoutConstraint.activate([
            buttonDesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonDesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonDesLabel.heightAnchor.constraint(equalToConstant: 40),
            buttonDesLabel.bottomAnchor.constraint(equalTo: flatButton.topAnchor, constant: -10)
            ])
        
        buttonDesLabel.text = "Restart game"
        
    }
    
    func setupPassScreen() {
        self.view.backgroundColor = UIColor.FlatColor.Green.mountainMeadow
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -45)
            ])
        
        titleLabel.center = self.view.center
        titleLabel.text = "Wow!"
        
        self.view.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0)
            ])
        
        subTitleLabel.text = "You found an error!"
        
        self.view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            scoreLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40)
            ])
        
        scoreLabel.text = "Current score: \(self.score)"
        
        addProceedButton()
        
        // FIXME:
        self.view.addSubview(buttonDesLabel)
        NSLayoutConstraint.activate([
            buttonDesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonDesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonDesLabel.heightAnchor.constraint(equalToConstant: 40),
            buttonDesLabel.bottomAnchor.constraint(equalTo: flatButton.topAnchor, constant: -10)
            ])
        
        buttonDesLabel.text = "Continue"
        
        circleProgress = CircularProgress()
        
        view.layer.addSublayer(circleProgress)
        circleProgress.initialize(point: flatButton.center, radius: (buttonSideLength + 15) / 2, lineWidth: 4)
        
        activateTimer()

    }
    
    func setupProceedScreen() {
        self.view.backgroundColor = UIColor.FlatColor.Green.mountainMeadow
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -45)
            ])
        
        titleLabel.center = self.view.center
        titleLabel.text = "Wow!"
        

        
        self.view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
            ])
        
        scoreLabel.text = "Current score: \(self.score)"
        
        addProceedButton()
        
        // FIXME:
        self.view.addSubview(buttonDesLabel)
        NSLayoutConstraint.activate([
            buttonDesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonDesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonDesLabel.heightAnchor.constraint(equalToConstant: 40),
            buttonDesLabel.bottomAnchor.constraint(equalTo: flatButton.topAnchor, constant: -10)
            ])
        
        buttonDesLabel.text = "Continue"
        
        circleProgress = CircularProgress()
        
        view.layer.addSublayer(circleProgress)
        circleProgress.initialize(point: flatButton.center, radius: (buttonSideLength + 15) / 2, lineWidth: 4)
        
        activateTimer()
        
    }
    
    @objc private func proceedToNext() {
        timer.invalidate()
        let gotoVC = TutorialViewController()
        gotoVC.moveScore(score: score)
        gotoVC.transitioningDelegate = self
        gotoVC.modalPresentationStyle = .custom
        self.present(gotoVC, animated: true, completion: nil)
    }
    
    private func addProceedButton() {
        self.view.addSubview(flatButton)
        
        NSLayoutConstraint.activate([
            flatButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flatButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
        
        flatButton.initType(type: .Ok)
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(proceedToNext))
        flatButton.addGestureRecognizer(buttonTap)
    }
    
    private func addCloseButton() {
        self.view.addSubview(flatButton)
        
        NSLayoutConstraint.activate([
            flatButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flatButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
        
        flatButton.initType(type: .Close)
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        flatButton.addGestureRecognizer(buttonTap)
    }
    
    private func setupLoadingScreen() {
        self.view.backgroundColor = Theme.backgroundColor()
    }
    

    
    @objc func buttonTapped() {
        timer.invalidate()
        let tVC = TutorialViewController()
        tVC.initRandomType()
        tVC.transitioningDelegate = self
        tVC.modalPresentationStyle = .custom
        self.present(tVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
