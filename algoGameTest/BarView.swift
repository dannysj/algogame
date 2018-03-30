//
//  BarView.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/29/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

protocol UpdateLeakyStatusDelegate {
    func updateStatusLeaky()
    func updateStatusNormal()
}

enum DirectionCase {
    case Up
    case Down
}

// for int
class BarView: UIView {
    
    var delegate: UpdateLeakyStatusDelegate?
    var arr: [Int] = []
    var leaky: Bool = false {
        didSet {
            if leaky {
                delegate?.updateStatusLeaky()
            } else {
                delegate?.updateStatusNormal()
            }
        }
    }
    
    // view, parallel to the initial arr
    private lazy var bars: [UIView] = {
        let b = [UIView]()
        return b
    }()
    private lazy var centerView: UIView = {
        let v = UIView()
        return v
    }()
    // bar property
    private var padding: CGFloat = 5.0
    private var barWidth: CGFloat = 20.0
    private var sidePadding: CGFloat = 15.0
    private var ratio: CGFloat = 15.0
    
    // elements
    private lazy var pointer: Pointer = {
        let v = Pointer()
        v.bounds = CGRect(x: 0, y: 0, width: barWidth, height: barWidth)
        //v.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(v)
        return v
    }()
    
    func initDataStructure(arr: [Int]) {
        self.arr = arr
        initUIStructure()
    }
    
    private func initUIStructure() {
        let frame = self.bounds
        barWidth = min((frame.width - (padding * CGFloat(arr.count - 1)) - sidePadding * 2) / CGFloat(arr.count) , barWidth)
        if barWidth < padding  {
            padding = barWidth / 3
            barWidth = (frame.width - (padding * CGFloat(arr.count - 1)) - sidePadding * 2) / CGFloat(arr.count)
        }
        
        // init centerView
        let cgcount = CGFloat(arr.count)
        let centerViewWidth = barWidth * cgcount + padding * cgcount + 2 * sidePadding
        centerView.bounds = CGRect(x: 0, y: 0, width: centerViewWidth, height: frame.height)
        centerView.center = CGPoint(x: frame.midX, y: frame.midY)
        addSubview(centerView)
        var x = sidePadding
        let btmAxis: CGFloat = centerView.bounds.maxY
        for i in 0 ..< arr.count {
            let bar = UIView()
            let height = CGFloat(arr[i] ) * ratio
            
             x = sidePadding + padding * CGFloat(i) + barWidth * CGFloat(i)
            print(x)
            bar.bounds = CGRect(x: 0, y: 0, width: barWidth, height: height)
            bar.center = CGPoint(x: x + barWidth / 2.0, y: btmAxis - height / 2.0)
            centerView.addSubview(bar)
            
            let r = random(min: 0, max: 255)
            let g = random(min: 0, max: 255)
            let b = random(min: 0, max: 255)
            
            let layer = CAShapeLayer()
            layer.frame = bar.bounds
            layer.path = UIBezierPath(roundedRect: layer.frame, cornerRadius: barWidth * 0.1).cgPath
            layer.fillColor = UIColor(red: r, green: g, blue: b).cgColor
            layer.strokeColor = Theme.lineColor().cgColor
            layer.lineWidth = 1.5
            bar.layer.addSublayer(layer)
            
            bars.append(bar)
        }
    }
    
    // MARK: UI updater
    
    public func exchange(from: Int, to: Int) {
        shiftStart(at: from, direction: .Up)
        shiftStart(at: to, direction: .Down)
        move(from: from, to: to)
        shiftEnd(at: from)
        shiftEnd(at: to)
    }
    
    public func shiftStart(at: Int, direction: DirectionCase) {
        let v = self.bars[at]
        var toY: CGFloat = 0
        switch direction {
        case .Up:
            toY = self.centerView.bounds.minY
        case .Down:
            toY = self.centerView.bounds.maxY + v.bounds.height / 1.5
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        
            v.center = CGPoint(x: v.center.x, y: toY)
        }, completion: nil)
    }
    
    public func move(from: Int, to: Int) {
        let fromNode = bars[from]
        let toNode = bars[to]
        let fromX = fromNode.center.x
        let toX = toNode.center.x
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            fromNode.center = CGPoint(x: toX, y: fromNode.center.y)
            toNode.center = CGPoint(x: fromX, y: toNode.center.y)
        }) {
            bool in
            self.bars.swapAt(from, to)
            self.arr.swapAt(from, to)
            
        }
    }
    
    public func shiftEnd(at: Int) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            let v = self.bars[at]
            v.center = CGPoint(x: v.center.x, y: self.centerView.bounds.maxY - v.bounds.height / 2.0)
        }, completion: nil)
    }
    
    public func pointer(at: Int) {
        
        let v = bars[at]
        pointer.center = CGPoint(x: v.center.x,  y: v.frame.minY - barWidth * 1.0 )

    }
    
    public func removePointer() {
        pointer.removeFromSuperview()
    }
    
    public func dashedLine(at: Int, from: Int) {
        let atNode = bars[at]
        let beginNode = bars[from]
        
        let line = CAShapeLayer()
        
        let maxY = atNode.frame.origin.y - 5
        let atX = atNode.frame.maxX
        let beginX = beginNode.frame.origin.x
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: atX, y: maxY))
        path.addLine(to: CGPoint(x: beginX, y: maxY))
        
        
        line.path = path.cgPath
        line.lineCap = kCALineCapRound
        line.lineJoin = kCALineJoinRound
        line.strokeColor = UIColor.FlatColor.Blue.aliceBlue.cgColor
        line.lineDashPattern = [12,8]
        line.lineWidth = 4.0
        
        centerView.layer.addSublayer(line)
    }
    
    // MARK: Algorithm
    
    func insertionSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else {
            return array
        }
        
        var sorted = array
        for i in 1 ..< sorted.count {
            var y = i
            let temp = sorted[y]
            // increasing order sort
            while y > 0 && temp < sorted[y-1]{
                sorted[y] = sorted[y - 1]
                y -= 1
            }
            sorted[y] = temp
        }
        return sorted
    }
    
    // random quick sort
    /* Reference: Intro to Algorithms (cormen)
     algorithm quicksort(A, lo, hi) is
     if lo < hi then
     p := partition(A, lo, hi)
     quicksort(A, lo, p - 1 )
     quicksort(A, p + 1, hi)
     
     algorithm partition(A, lo, hi) is
     pivot := A[hi]
     i := lo - 1
     for j := lo to hi - 1 do
     if A[j] < pivot then
     i := i + 1
     swap A[i] with A[j]
     swap A[i + 1] with A[hi]
     return i + 1
     */
    func quickSort<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
        if low < high {
            let pivotIndex = random(min: low, max: high)
            
            // swap pivotIndex to high , to put pivot at the end
            (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])
            
            let p = partition(&a, low: low, high: high)
            quickSort(&a, low: low, high: p-1)
            quickSort(&a, low: p+1, high: high)
        }
        
    }
    
    // partition
    func partition<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
        let pivot = a[high]
        
        var i = low
        for j in low ..< high {
            if a[j] <= pivot {
                (a[i], a[j]) = (a[j], a[i])
                i += 1
            }
        }
        
        // swap the pivot keke
        (a[i], a[high]) = (a[high] , a[i])
        
        // pivot!
        return i
    }

}
