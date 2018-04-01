//
//  GraphViewController.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/29/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, UIViewControllerTransitioningDelegate, UpdateGraphStatusDelegate {
    // for transition
    let transition = BotFadeTransition()
    
    // graph data structure
    private var graph: AdjacencyListGraph<String>!
    private let maxNodeCount: Int = 10
    private let minNodeCount: Int = 6
    // for graph UI
    private let center: Center<ViewNode> = Center(center: .zero)
    private let manyNodes: ManyNodes<ViewNode> = ManyNodes()
    private let system: System<ViewNode> = System()
    
    private let velocityRate: CGFloat = 0.05
    private var weightRate: CGFloat = 10
    
    private let main = DispatchQueue.main
    private let global = DispatchQueue.global()
    
    //leaky
    private var isLeaky: Bool = true
    
    // graph
    fileprivate lazy var forceDirectedGraph: ForceDirectedGraph<ViewNode> = {
        let fdg: ForceDirectedGraph<ViewNode> = ForceDirectedGraph()
        fdg.insertForce(self.manyNodes)
        fdg.insertForce(self.system)
        fdg.insertForce(self.center)
        fdg.insertTick({ self.linkLayer.path = self.system.arrow(from: &$0) })
        
        return fdg
    } ()
    
    // timer
    private var timer: Timer = Timer()
    private var timeLimit: Double = 5
    private var currentTime: Double = 0
    private var circleProgress: CircularProgress!
    private lazy var bot: HexagonBot = {
        let b = HexagonBot()
        b.bounds = CGRect(x: 0, y: 0, width: 40, height: 50)
        b.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(b)
        return b
    }()
    
    private lazy var linkLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        self.view.layer.insertSublayer(layer, at: 0)
        return layer
    } ()
    
    private var buttonSideLength: CGFloat = 80.0
    
    // Other UI elements
    private lazy var flatButton: FlatButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: buttonSideLength, height: buttonSideLength)
        let button = FlatButton(frame: buttonRect)
        button.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 30 - buttonSideLength / 2.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var containerHeight: CGFloat = 200
    private var container: CurrentContainer!
    
    private var gameLabel: UILabel!
    
    private var currentBotNode: Int = 0
    private var nodeSize: CGFloat = 30
    private var botOffset: CGFloat = 0
    
    // for bot tracking purpose
    private var nodesLoc: [Int] = []
    private var botNode: ViewNode!
    
    // code type
    private var codeType: CodeType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0x17264B)
        
        // Do any additional setup after loading the view.
        //setupGraphWithNodes()

        botOffset = nodeSize / 2.0

        // Bad way to
       
        setupGraph()
        setupView()
    }
    
    // MARK: When View appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //updateBotLocation(nodeIndex: 0)
        forceDirectedGraph.start()
        activateTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        forceDirectedGraph.stop()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //setupView()
    }
    
    // MARK: setup methods
    
    func setupView() {
        linkLayer.frame = view.bounds
        center.center = CGPoint(x: linkLayer.frame.midX, y: linkLayer.frame.midY)
        
        self.view.addSubview(flatButton)
        
        NSLayoutConstraint.activate([
            flatButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flatButton.heightAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.widthAnchor.constraint(equalToConstant: buttonSideLength),
            flatButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
        
        flatButton.initType(type: .Alert)
        
        // some timer
        circleProgress = CircularProgress()
        
        view.layer.addSublayer(circleProgress)
        circleProgress.initialize(point: flatButton.center, radius: (buttonSideLength + 15) / 2, lineWidth: 4)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(runAlgorithm))
        flatButton.addGestureRecognizer(tapGR)
        
        // debug
        gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameLabel)
        
        NSLayoutConstraint.activate([
            gameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            gameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            gameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
            ])
        
        gameLabel.text = "\(graph.vertices.count)"
        gameLabel.font = Theme.codeTitleFont()
        gameLabel.textAlignment = .center
        gameLabel.textColor = Theme.lineColor()
        
        setupContainer()
        //
        switch codeType {
     
            case .dfsnonlexi:
                container.initType(type: .Stack)
            case .bfs:
                container.initType(type: .Queue)
            case .dijkstra:
                container.initType(type: .PriorityQueue)
            
            default:
                // do nth
                break
        }
        
        
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
        currentTime += 1
        
        if (currentTime == timeLimit) {
            print("5 seconds")
            if isLeaky {
                let statusVC = StatusViewController()
                statusVC.updateStatus(status: .Failed)

                self.present(statusVC, animated: false, completion: nil)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGraph() {
        var success:Bool = randomSetupGraph()
        while !success {
            success = randomSetupGraph()
        }
    }
    func initCodeType(type: CodeType) {
        self.codeType = type
    }
    
    func setupContainer() {
        //setup container
        container = CurrentContainer(frame: CGRect(x: 0, y: 0, width: 50, height: containerHeight))
        
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: gameLabel.bottomAnchor, constant: 15),
            container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            container.heightAnchor.constraint(equalToConstant: containerHeight),
            container.widthAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    func randomSetupGraph() -> Bool {
        graph = AdjacencyListGraph<String>()
        graph.delegate = self
        let nodeCount = random(min: minNodeCount, max: maxNodeCount)
        
        containerHeight = CGFloat(nodeCount * 25 + 35)
        
        var unconnected: [Int] = []
        _ = graph.createVertex("\(0)")
        // 0th index will be starting node
        for i in 1 ..< nodeCount {
            _ = graph.createVertex("\(i)")
            unconnected.append(i)
            //availableConnections.append([])
        }
        
        // choose a starting point
        let startNode = graph.vertices[0]
        
        // determine how many levels
        let maxNum = min(4, nodeCount - 1)
        let nodesPerLevel: Int = random(min: 2, max: maxNum)
        
        // modulus
        for i in 0 ..< nodesPerLevel {
            let endNode = graph.vertices[unconnected[i]]
            let randomWeight = Double(random(min: 5, max: 15)) * 10
            graph.addDirectedEdge(from: startNode, to: endNode, withWeight: randomWeight)
            
        }
        
        for _ in 0 ..< nodesPerLevel {
            unconnected.removeFirst()
        }
        
        // iterate each level, replace array, unconnected for that level, check SCC
        while !unconnected.isEmpty {

            var rFromIndex = random(min: 1, max: nodeCount - 1)
            //let rToIndex = Int(arc4random_uniform(UInt32(unconnected.count)))
            let rToIndex = random(min: 1, max: nodeCount - 1)
            
            guard rFromIndex != rToIndex else { continue }
            
            var aNode = graph.vertices[rFromIndex]
            let bNode = graph.vertices[rToIndex]
            let randomWeight = Double(random(min: 5, max: 15)) * 10
            graph.addDirectedEdge(from: aNode, to: bNode, withWeight: randomWeight)
            
            // FIXME: N^3 !
            // If SCC > 10 times, reset graph
            var sccCounter = 0
            while graph.stronglyConnected() {
                if ( sccCounter > nodeCount ) {
                    return false
                }
                sccCounter += 1
              
                graph.removeLastDirectedEdge(from: aNode)
                rFromIndex = random(min: 1, max: nodeCount - 1)
                while rFromIndex == rToIndex  {
                    rFromIndex = random(min: 1, max: nodeCount - 1)
  
                }
                aNode = graph.vertices[rFromIndex]
                graph.addDirectedEdge(from: aNode, to: bNode, withWeight: randomWeight)
            }
            
            if unconnected.contains(rToIndex) {
                unconnected.remove(at: unconnected.index(of: rToIndex)!)
            }
        }
        
        
        // now setupUI
        var nodes: [ViewNode] = []
        for _ in 0 ..< graph.vertices.count {
            let r = random(min: 0, max: 255)
            let g = random(min: 0, max: 255)
            let b = random(min: 0, max: 255)
            let n = node(color: UIColor(red: r, green: g, blue: b), diameter: nodeSize, fixed: false)
            nodes.append(n)
            nodesLoc.append(n.hashValue)
            

        }
        
        for e in graph.edges {
            print("Stick")
            if let aIndex = graph.vertices.index(of: e.from),let bIndex = graph.vertices.index(of: e.to) {
                guard aIndex != bIndex else {
                    fatalError()
                }
                 let dis = CGFloat(e.weight!)
                

                if codeType == .dijkstra {
       
                    let n = node(color: UIColor.clear, diameter: nodeSize, fixed: false, isWeight: true, distance: dis)
                    let firstHalfLength: CGFloat = nodeSize / 3.0
                    system.link(from: n, to: nodes[aIndex], distance: dis / 2.0 - firstHalfLength, strength: nil, transparent: false, halfway: true)
                    system.link(from: n, to: nodes[bIndex], distance: dis / 2.0 - firstHalfLength, strength: nil)
                }
                else {
                     system.link(from: nodes[aIndex], to: nodes[bIndex], distance: dis)
                }
            }
            else {
                fatalError()
            }
            
        }
        
        botNode = ViewNode(view: bot, fixed: false)
        forceDirectedGraph.insertNode(botNode)
        system.link(from: botNode, to: nodes[0], distance: botOffset, transparent: true)
        currentBotNode = 0
        

        print("Ended")
        // success
        return true
    }
    
    func setupGraphWithNodes() {
        let a = node(color: UIColor(hex: 0xCC4250), diameter: nodeSize, fixed: false)
        let b = node(color: UIColor(hex: 0x43BD47), diameter: nodeSize, fixed: false)
        let c = node(color: UIColor(hex: 0x43BD47), diameter: nodeSize, fixed: false)
        let d = node(color: UIColor(hex: 0x4CB3BC), diameter: nodeSize, fixed: false)
        let e = node(color: UIColor(hex: 0x4CB3BC), diameter: nodeSize, fixed: false)
        let f = node(color: UIColor(hex: 0xCB824A), diameter: nodeSize, fixed: false)
        //let g = node(color: UIColor(hex: 0xFFFFFF), diameter: 30, fixed: false)
        
        system.link(from: a, to: b, distance: 100)
        system.link(from: a, to: c, distance: 100)
        system.link(from: c, to: b, distance: 30)
        system.link(from: d, to: b, distance: 100)
        system.link(from: e, to: c, distance: 80)
        system.link(from: e, to: f, distance: 100)
        
        nodesLoc.append(a.hashValue)
        nodesLoc.append(b.hashValue)
        nodesLoc.append(c.hashValue)
        nodesLoc.append(d.hashValue)
        nodesLoc.append(e.hashValue)
        nodesLoc.append(f.hashValue)
        
        botNode = ViewNode(view: bot, fixed: false)
        forceDirectedGraph.insertNode(botNode)
        system.link(from: botNode, to: a, distance: botOffset, transparent: true)
        currentBotNode = 0
        
    }
    
    // MARK: debug
    @objc private func randomTest() {
        let i = random(min: 0, max: nodesLoc.count - 1)
        updateBotLocation(nodeIndex: i)
    }

    // MARK: Helper methods: Creating node + Bot update
    
    private func node(color: UIColor, diameter: CGFloat, fixed: Bool, isWeight: Bool = false, distance: CGFloat = 0.0) -> ViewNode {
        let view = UIView()
        let pad: CGFloat = 10.0
        
        view.center = CGPoint(x: CGFloat(arc4random_uniform(320)), y: -CGFloat(arc4random_uniform(100)))
        view.bounds = CGRect(x: 0, y: 0, width: diameter + pad * 2, height: diameter + pad * 2)
        view.alpha = 0.3
        self.view.addSubview(view)
        
        if isWeight {
   
            let label = UILabel()
            label.font = Theme.codeFont()
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = "\(Double(distance))"
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalTo: view.heightAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
            view.backgroundColor = UIColor.clear
            view.alpha = 1.0
        }
        else {
            let layer = CAShapeLayer()
            layer.frame = view.bounds
            layer.path = UIBezierPath(ovalIn: layer.frame.insetBy(dx: pad, dy: pad)).cgPath
            layer.fillColor = color.cgColor
            layer.strokeColor = Theme.lineColor().cgColor
            layer.lineWidth = 2
            view.layer.addSublayer(layer)
            
            if codeType == .dijkstra {

                print("It's dijkstra3")
                let label = UILabel()
                label.font = Theme.codeFont() 
                label.textColor = UIColor.white
                label.textAlignment = .center
                label.attributedText = NSAttributedString(string: "∞")
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)
                NSLayoutConstraint.activate([
                    label.heightAnchor.constraint(equalTo: view.heightAnchor),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                    ])
                
            }
            

        }
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(dragged(_:)))
        view.addGestureRecognizer(panGR)
        
        //finally
        let node = ViewNode(view: view, fixed: fixed)
        forceDirectedGraph.insertNode(node)
        return node
        
    }
    
    private func updateBotLocation(nodeIndex: Int) {
        var targetNode: ViewNode? = nil
        var previousNode: ViewNode? = nil
        
        for n in forceDirectedGraph.nodes {
            if (targetNode != nil && previousNode != nil) {
                break
            }
            if n.hashValue == nodesLoc[nodeIndex] {
                targetNode = n
            }
            if n.hashValue == nodesLoc[currentBotNode] {
                previousNode = n
            }
        }
        
        guard targetNode != nil && previousNode != nil else {
            print("Failed to find")
            return
        }
 
        system.unlink(from: botNode, to: previousNode!)
        system.link(from: botNode, to: targetNode!, distance: botOffset, transparent: true)
        print(currentBotNode)
        currentBotNode = nodeIndex
        print ("Setted position")
        print(currentBotNode)
        forceDirectedGraph.testRun()
       

    }
    
    @objc private func dragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        // FIXME: if it's fixed, you can't move shit
        guard let view = gestureRecognizer.view, let index = forceDirectedGraph.nodes.index(of: ViewNode(view: view, fixed: false)) else {
            return
        }
        var node = forceDirectedGraph.nodes[index]
        switch gestureRecognizer.state {
        case .began:
            node.fixed = true
        case .changed:
            node.position = gestureRecognizer.location(in: self.view)
            forceDirectedGraph.reset()
        case .cancelled, .ended:
            node.fixed = false
            node.velocity += gestureRecognizer.velocity(in: self.view) * velocityRate
        default:
            break
        }
        forceDirectedGraph.nodes.update(with: node)
        
    }
    
    // MARK: Run Algortihm
    @objc func runAlgorithm() {
        print("Running algorithm")
        let vertices = graph.topologicalSort()
        if let s = vertices.first {
        
            global.async {
                switch self.codeType {
                    case .dfslexi:
                        _ = self.graph.dfs_lexi(source: s)
                    case .dfsnonlexi:
                        _ = self.graph.dfs_nonlexi(source: s)
                    case .bfs:
                        _ = self.graph.bfs(source: s)
                    case .dijkstra:
                        self.graph.dijkstra(source: s)

                    default:
                        fatalError("This is graph, unexpected nongraph algorithm")
                }
                
            }
        }
    }
    
    // Delegate method
    func updateVertexPosition(at: Int) {
        main.sync {
            self.updateBotLocation(nodeIndex: at)
        }
        sleep(1)
    }
    
    func updateExplored(at: Int) {
        var node: ViewNode? = nil
        
        for n in forceDirectedGraph.nodes {

            if n.hashValue == nodesLoc[at] {
                node = n
                break
            }

        }
        main.sync {
            UIView.animate(withDuration: 0.3, animations: {
                node?.explored = true
            })
            print("Updated")
        }
        sleep(1)
    }
    
    func updateDijkstraLabel(at: Int, value: Double, fromValue: Double) {
        print("Hmm")
        var node: ViewNode? = nil
        
        for n in forceDirectedGraph.nodes {
            
            if n.hashValue == nodesLoc[at] {
                node = n
                break
            }
            
        }
        if let n = node {
            if let textLabel = n.view.takeUnretainedValue().subviews[0] as? UILabel {
                
                let attr: [NSAttributedStringKey : Any] = [ NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font:UIFont(name: "Menlo-Regular", size: 5) ]
                
                let attributedTextSmall = NSMutableAttributedString(string: "\(fromValue)->\n", attributes: attr)
                
                let attr1: [NSAttributedStringKey : Any] = [ NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font:UIFont(name: "Menlo-Regular", size: 8) ]
                
                let attributedText = NSMutableAttributedString(string: "\(value)", attributes: attr1)
                attributedTextSmall.append(attributedText)
                
                
                main.async {
                    textLabel.textAlignment = .center
                    textLabel.numberOfLines = 0
                    textLabel.attributedText = attributedTextSmall
                    self.container.updateLabel(index: at, string: attributedTextSmall.string)
                }
                
            }
        }
        
    }
    
    func updateDataStructure(at: Int, mode: Int) {
        var node: ViewNode? = nil
        
        for n in forceDirectedGraph.nodes {
            
            if n.hashValue == nodesLoc[at] {
                node = n
                break
            }
            
        }
        if let n = node {
            //main.async {
                let test = n.view.takeUnretainedValue().layer.sublayers![0] as! CAShapeLayer
                var text = ""
                if let textLabel = n.view.takeUnretainedValue().subviews[0] as? UILabel {
                    text = (textLabel.attributedText?.string)!
                    
                }
            print("Text obtained: \(text)")
                if mode == 1 {
                    
                    self.main.sync {
                        self.container.add(pair: (at, test.fillColor!, text))
                    }
                }
                else {
                    // remove
                    self.main.sync {
                        self.container.remove(index: at)
                    }
                }

                print("Text is \(text)")
          //  }

        }


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


