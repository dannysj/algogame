//
//  CurrentContainer.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/30/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

enum ContainerType {
    case Stack
    case PriorityQueue
    case Queue
}

class CurrentContainer: UIView {
    
    typealias Pairs = (Int, CGColor, String)
    private var type: ContainerType!
    private var arr: [Pairs] = []
    private var cellID: String = "nodeCell"
    // nested UICollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 25, height: 25)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var arrayView: UIView = {
        let view = UIView()
        print("View")
        print("\(self.bounds)")
        //view.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 35)
        print("\(view.bounds)")

        print("\(view.center)")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var label: UnderlineLabel = {
        let l = UnderlineLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "Menlo-Regular", size: 8)
        l.textColor = UIColor.white
        return l
    }()
    
    public func initType(type: ContainerType) {
        self.type = type
    }
    
    public func arrange() {
        if type == .PriorityQueue {
            arr.sort(by: { $0.2 < $1.2 })
        } else if type == .Stack {
            //arr.reverse()
        }
        updateStat()
    }
    
    public func add(pair:  Pairs) {
        arr.append(pair)
        arrange()
    }
    
    public func remove(index:  Int) {
        var x: Pairs? = nil
        var i: Int = -1
        for j in 0 ..< arr.count {
            let  p = arr[j]
            if p.0 == index {
                x = p
                i = j
                break
            }
        }
        arr.remove(at: i)
        arrange()
        print("Removing x")
        print(x!.0)
        print("TEST")
        for a in arr {
            print(a.0)
        }
        showRemovedItem(x!)
    }
    
    public func updateLabel(index: Int, string: String) {
        for j in 0 ..< arr.count {
    
            if arr[j].0 == index {
                arr[j].2 = string
                arrange()
                break
            }
        }
        
    }
    
    public func showRemovedItem(_ pair: Pairs) {
        let v = node(color: pair.1, diameter: 30, text: pair.2)
        v.alpha = 0
        //FIXME: position
        let newCenter = CGPoint(x: self.bounds.minX - 10, y: label.bounds.maxY )
        v.center = CGPoint(x: collectionView.center.x, y: label.bounds.maxY)
        print(v.center)
        self.addSubview(v)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            v.alpha = 1
            v.center = newCenter
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                v.alpha = 0
            }) { bool in
                v.removeFromSuperview()
            }
        }
        
        
    }
    
    private func updateStat() {
        guard arr.count > 0 else { return }
       
        self.collectionView.performBatchUpdates({
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }, completion: nil)
    }

    private func setupStructure() {
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 30)
            ])
        switch type {
            case .Stack:
                label.text = "Stack"
            case .PriorityQueue:
                label.text = "Priority Q"
            
            case .Queue:
                label.text = "Queue"
            default:
                // shouldnt be here
                fatalError()
        }
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor,  constant: -5),
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        updateStat()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStructure()
    }
    
    private func node(color: CGColor, diameter: CGFloat, text: String = "") -> UIView {
        let view = UIView()
        let pad: CGFloat = 10.0
        
        view.bounds = CGRect(x: 0, y: 0, width: diameter + pad * 2, height: diameter + pad * 2)
        view.alpha = 0.7
        
    
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = UIBezierPath(ovalIn: layer.frame.insetBy(dx: pad, dy: pad)).cgPath
        layer.fillColor = color
        layer.strokeColor = Theme.lineColor().cgColor
        layer.lineWidth = 2
        view.layer.addSublayer(layer)
        
        let label = UILabel()
        label.font = Theme.codeFont()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: view.heightAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
   
        return view
    }
    
}

extension CurrentContainer: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        let view = cell.contentView
        var index = indexPath.item
        if type == .Stack {
            index = arr.count - index - 1
        }
        let item = arr[index]
        let pad: CGFloat = 2.5
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = UIBezierPath(ovalIn: layer.frame.insetBy(dx: pad, dy: pad)).cgPath
        layer.fillColor = item.1
        layer.strokeColor = Theme.lineColor().cgColor
        layer.lineWidth = 1
        view.layer.addSublayer(layer)
        
        let label = UILabel()
        label.font = UIFont(name: "Menlo-Regular", size: 6)
        label.textColor = UIColor.white
        label.textAlignment = .center
        var text = item.2
        let g = text.components(separatedBy: CharacterSet.newlines)
        if g.count > 1 {
            text = g[1]
        }
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: view.heightAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
