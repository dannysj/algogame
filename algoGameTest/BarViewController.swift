//
//  BarViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateLeakyStatusDelegate {
    // keep track error
    private var leakyStatus: Bool = false
    private var minBarCount: Int = 5
    private var maxBarCount: Int = 10
    var barCount: Int = 0
    // private lazy var
    private lazy var barView: BarView = {
        let bv = BarView()
        bv.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2.5)
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    var barCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.backgroundColor()
        // Do any additional setup after loading the view.
        initBarView()
    }
    
    func initBarView() {
        self.view.addSubview(barView)
        NSLayoutConstraint.activate([
            barView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            barView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65),
            barView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2.5)
            ])
        barCount = random(min: minBarCount, max: maxBarCount)
        var barData: [Int] = []
        for _ in 0 ..< barCount {
            barData.append(random(min: 3, max: maxBarCount))
        }
        barData.shuffle()
        print(barData)
        barView.initDataStructure(arr: barData)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(randomTest))
        view.addGestureRecognizer(tapGR)
        
        barView.pointer(at: 2)
        barView.dashedLine(at: 3, from: 0)
    }
    
    @objc func randomTest() {
     
        barView.exchange(from: barCounter, to: barCount - barCounter - 1)
        barCounter += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateStatusLeaky() {
        leakyStatus = true
    }
    
    func updateStatusNormal() {
        leakyStatus = false
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
