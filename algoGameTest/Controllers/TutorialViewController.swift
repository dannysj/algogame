//
//  TutorialViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var timer: Timer = Timer()
    private var codeType: CodeType!
    private var timeLimit: Double = 5
    private var circleProgress: CircularProgress!
    private var consoleHeight: CGFloat = 300.0
    private var codeVHeight: CGFloat = 100.0 {
        didSet {
            consoleHeight = codeVHeight + 30 + 30 + 15
        }
    }
    private var labelHeight: CGFloat = 0 {
        didSet {
            consoleHeight = codeVHeight + labelHeight + 30 + 15
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
    
    private lazy var codeVisualizer: CodeVisualizer = {
        let v = CodeVisualizer()
        v.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: codeVHeight)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // button
    private lazy var infoButton: FlatButton = {
        let length = buttonSideLength / 2.0
        let buttonRect = CGRect(x: 0, y: 0, width: length, height: length)
        let button = FlatButton(frame: buttonRect)
        button.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 30 - length / 2.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.backgroundColor()
        // Do any additional setup after loading the view.
        // set code type
        codeType = .dfslexi
        showScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showScreen() {
        
        codeVHeight = codeType.code.joined(separator: "\n").heightForString(font: Theme.codeFont(), width: self.view.bounds.width - 60 * 2)
        
        self.view.addSubview(consoleView)
        NSLayoutConstraint.activate([
            consoleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            consoleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            consoleView.heightAnchor.constraint(equalToConstant: consoleHeight),
            consoleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        
        self.view.insertSubview(bot, belowSubview: consoleView)
        NSLayoutConstraint.activate([
            bot.widthAnchor.constraint(equalToConstant: 80),
            bot.heightAnchor.constraint(equalToConstant: 100),
            bot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bot.centerYAnchor.constraint(equalTo: consoleView.topAnchor, constant: -15)
            ])
        
        consoleView.addSubview(titleLabel)
        labelHeight = codeType.name.heightForString(font: Theme.codeTitleFont(), width: self.view.bounds.width - 60 * 2)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: consoleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: consoleView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: consoleView.topAnchor, constant: 30),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            ])
        
        
        // code visualizer
        consoleView.addSubview(codeVisualizer)
        NSLayoutConstraint.activate([
            codeVisualizer.leadingAnchor.constraint(equalTo: consoleView.leadingAnchor),
            codeVisualizer.trailingAnchor.constraint(equalTo: consoleView.trailingAnchor),
            codeVisualizer.bottomAnchor.constraint(equalTo: consoleView.bottomAnchor, constant: 15),
            codeVisualizer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
            ])
        
        codeVisualizer.initCodeType(type: codeType)
        
        addOkButton()
        addInfoButton()
    }
    
    func moreInfo() {
        // remove all stuffs,
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
        
    }
    
    private func addInfoButton() {
        self.view.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            infoButton.leadingAnchor.constraint(equalTo: bot.trailingAnchor, constant: 45),
            infoButton.heightAnchor.constraint(equalToConstant: buttonSideLength / 2.0),
            infoButton.widthAnchor.constraint(equalToConstant: buttonSideLength / 2.0),
            infoButton.bottomAnchor.constraint(equalTo: bot.bottomAnchor, constant: -15)
            ])
        
        infoButton.initType(type: .Info)
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(infoButtonTapped))
        okButton.addGestureRecognizer(buttonTap)
    }
    
    @objc func infoButtonTapped() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
