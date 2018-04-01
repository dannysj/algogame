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
}

class StatusViewController: UIViewController, UIViewControllerTransitioningDelegate {
    // for transition
    let transition = BotFadeTransition()
    private var status: GameStatus! {
        didSet {
            switch status {
            case .Loading:
                setupLoadingScreen()
            case .Pass:
                setupSuccessScreen()
            case .Failed:
                setupFailScreen()
            default:
                fatalError("Shouldn't be here")
            }
        }
    }
    
    private lazy var circleProgress: CircularProgress = {
        let v = CircularProgress()
        
        return v
    }()
    
    private lazy var score: Int = {
        let i: Int =  0
        return i
    } ()
    
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateScore(score: Int) {
        self.score = score
    }
    
    func updateStatus(status: GameStatus) {
        self.status = status
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
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
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
            buttonDesLabel.bottomAnchor.constraint(equalTo: flatButton.topAnchor, constant: -15)
            ])
        
        buttonDesLabel.text = "Restart game"
        
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
    
    private func setupSuccessScreen() {
        self.view.backgroundColor = UIColor.FlatColor.Green.mintDark
    }
    
    @objc func buttonTapped() {
        
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
