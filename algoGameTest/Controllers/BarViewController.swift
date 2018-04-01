//
//  BarViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class BarViewController: UIViewController, UIViewControllerTransitioningDelegate {
    // for transition
    let transition = BotFadeTransition()
    // timer
    private var timer: Timer = Timer()
    private var timeLimit: Double = 5
    private var currentTime: Double = 0
    // keep track error
    private var currentScore: Int = 0 {
        didSet {
            scoreLabel.text = "\(currentScore)"
        }
    }
    private var minBarCount: Int = 8
    private var maxBarCount: Int = 16
    private var circleProgress: CircularProgress!
    var barData: [Int] = []
    var barCount: Int = 0
    var barCounter: Int = 0
    private var barViewHeight: CGFloat = UIScreen.main.bounds.height / 3
    private var codeVHeight: CGFloat = 0
    private var isLeaky: Bool = false
    
    // private lazy var
    private lazy var barView: BarView = {
        let bv = BarView()
        bv.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: barViewHeight)
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
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
    
    private lazy var scoreLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.scoreFont()
        l.textAlignment = .center
        l.textColor = Theme.lineColor()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "\(0)"
        return l
    } ()
    
    private let main = DispatchQueue.main
    private let global = DispatchQueue.global()
    
    private var codeType: CodeType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.backgroundColor()
        // Do any additional setup after loading the view.
        codeVHeight = UIScreen.main.bounds.height - barViewHeight - buttonSideLength - 60
        codeType = CodeType.insertionSort
        
        initBarView()

    }
    
    
    func initCodeType(type: CodeType) {
        self.codeType = type
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activateTimer()
    }
    
    func activateTimer() {
        if timer.isValid {
            print("Timer is valid")
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        print("Activated timer")
        circleProgress.animate(toValue: timeLimit)
        randomTest()
    }
    
    @objc func timerRunning() {
        currentTime += 1
        
        if (currentTime == timeLimit) {
            print("5 seconds")
            if isLeaky {

                gotoHell()
            } else {
                
                // add marks
                currentScore += 5
                
                
            }
        }
 
    }
    
    func gotoHell() {
        if timer.isValid {
            timer.invalidate()
        }
        let statusVC = StatusViewController()
        statusVC.updateStatus(status: .Failed, score: currentScore)
        
        self.present(statusVC, animated: false, completion: nil)
    }
    
    func initBarView() {
        self.view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            scoreLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            scoreLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        self.view.addSubview(barView)
        NSLayoutConstraint.activate([
            barView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            barView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65),
            barView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2.5)
            ])
        barCount = random(min: minBarCount, max: maxBarCount)
        
        for _ in 0 ..< barCount {
            barData.append(random(min: 3, max: maxBarCount))
        }
        barData.shuffle()
        print(barData)
        barView.initDataStructure(arr: &barData)
        
        self.view.addSubview(flatButton)
        
        NSLayoutConstraint.activate([
            flatButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flatButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
        
        flatButton.initType(type: .Alert)
        
        self.view.addSubview(codeVisualizer)
        NSLayoutConstraint.activate([
            codeVisualizer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            codeVisualizer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            codeVisualizer.topAnchor.constraint(equalTo: barView.bottomAnchor),
            codeVisualizer.bottomAnchor.constraint(equalTo: flatButton.topAnchor, constant: -15)
            ])
       
        codeVisualizer.initCodeType(type: codeType, withScrollableWindow: true)
        

        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(testStart))
        flatButton.addGestureRecognizer(buttonTap)
        
        // some timer
        circleProgress = CircularProgress()
        
        view.layer.addSublayer(circleProgress)
        circleProgress.initialize(point: flatButton.center, radius: (buttonSideLength + 15) / 2, lineWidth: 4)
        
        barView.pointer(at: 0)
    
    }
    
    @objc func randomTest() {
     
        barView.exchange(from: barCounter, to: barCount - barCounter - 1)
        barCounter += 1
        let test = random(min: 0, max: barCount - 1)
        print("test \(test)")
        barView.pointer(at: test)
    }
    
    @objc func testStart() {
        //
        if isLeaky {
            // do smth if success
            
        }
        else {
            gotoHell()
        }

    }
    
    func runAlgorithm() {
        if codeType == .quickSort {
            global.async {
                self.quickSort(&self.barData, low: 0, high: self.barData.count - 1)
            }
        }
        else if codeType == .insertionSort {
            global.async {
                _ = self.insertionSort(self.barData)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: sorting functions
    func insertionSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else {
            return array
        }

        var sorted = array
        global.async {
            for i in 1 ..< sorted.count {
                
                self.updateUI {
                    self.barView.botPointer(at: i)
                }
                var y = i
                let temp = sorted[y]
                // increasing order sort
                self.updateUI {
                    self.barView.shiftStart(at: y, direction: .Up)
                }
                while y > 0 && temp < sorted[y-1]{
                    if !self.leakyOrNot() {
                        sorted[y] = sorted[y - 1]
                        self.updateUI {
                            self.barView.move(from: y - 1, to: y)
                        }
                    }
                    y -= 1
                }
                sorted[y] = temp
                self.updateUI {
                    self.barView.shiftEnd(at: y)
                }
              
            }
        }

        return sorted
    }
    
    // random quick sort

    func quickSort<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
        if low < high {
            let pivotIndex = random(min: low, max: high)
            if !self.leakyOrNot() {
                // swap pivotIndex to high , to put pivot at the end
                (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])
                updateUI {
                    self.barView.exchange(from: pivotIndex, to: high)
                    
                }
            }
            
            let p = partition(&a, low: low, high: high)
            // FIXME:
            
            quickSort(&a, low: low, high: p-1)
            quickSort(&a, low: p+1, high: high)
        }
        
    }
    
    // partition
    func partition<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
        let pivot = a[high]
        updateUI {
            self.barView.pivot(at: high)
            
        }
        // BOT
        var i = low
        updateUI {
            self.barView.pointer(at: i)
            self.barView.dashedLine(at: high, from: i)
        }
        for j in low ..< high {
            updateUI {
                self.barView.botPointer(at: j)
                //self.barView.shiftStart(at: j, direction: .Down)
            }
            
            if a[j] <= pivot {
                if !self.leakyOrNot() {
                    (a[i], a[j]) = (a[j], a[i])
                    updateUI {
                        self.barView.exchange(from: i, to: j)
                    }
                }
                // BOT
                i += 1
                updateUI {
                    self.barView.pointer(at: i)
                }
            }

        }
        
        // swap the pivot keke
        
        (a[i], a[high]) = (a[high] , a[i])
        updateUI {
            self.barView.exchange(from: i, to: high)
            self.barView.removeDashLine()
        }
        
        // pivot!
        updateUI {
            self.barView.removePivot()
            
        }
        return i
    }
    
    func updateUI( time: UInt32 = 1, _ function: ()->()) {
        main.sync {
            function()
        }
        sleep(time)
    }
    // MARK: - Navigation
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //transition.mode = .dismiss
        transition.color = Theme.backgroundColor()
        
        return transition
    }
    
    func leakyOrNot() -> Bool {
        // one leaky at a time
        if isLeaky {
            return false
        }
        let x =  arc4random_uniform(2) == 0
        if x {
            isLeaky = true
        }
        return x
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //transition.mode = .present
        transition.color = Theme.backgroundColor()
        
        return transition
    }
}
