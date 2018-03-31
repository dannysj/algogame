//
//  Graph.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/27/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//  Reference: Algorithm club

import Foundation

protocol UpdateGraphStatusDelegate {
    func updateVertexPosition(at: Int)
    func updateExplored(at: Int)
    func updateDijkstraLabel(at: Int, value: Double)
}

public class Edge<T>: Equatable where T: Hashable {
    public let from: Vertex<T>
    public let to: Vertex<T>
    
    public let weight: Double?
    
    public init(from: Vertex<T>, to: Vertex<T>, weight: Double) {
        self.from = from
        self.to = to
        self.weight = weight
    }
    
}

extension Edge: Hashable {
    static public func == <T> (lhs: Edge<T>, rhs: Edge<T> ) -> Bool {
        guard lhs.from == rhs.from else {
            return false
        }
        
        guard lhs.to == rhs.to else {
            return false
        }
        
        guard lhs.weight == rhs.weight else {
            return false
        }
        
        return true
    }
    
    // for hashing
    public var hashValue: Int {
        var string = "\(from.description)\(to.description)"
        if weight != nil {
            string.append("\(weight!)")
        }
        
        return string.hashValue
    }
}

public class Vertex<T>: Equatable where  T: Hashable {
    public var data: T
    public let index: Int
    public var dist: Double = Double.infinity
    //for bfs/dfs
    public var visited: Bool = false
    public var prev: Vertex<T>? = nil
    
    init(data: T, index: Int) {
        self.data = data
        self.index = index
    }
    
    
}

extension Vertex: Hashable, CustomStringConvertible {
    public static func == <T> (lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
        guard lhs.index == rhs.index else {
            return false
        }
        guard lhs.data == rhs.data else {
            return false
        }
        return true
    }
    
    // For hasihng purpose
    public var description: String {
        return "\(index): \(data)"
    }
    
    public var hashValue: Int {
        return "\(data)\(index)".hashValue
    }
    
}
// adjacency list
private class EdgeList<T> where T: Hashable {
    var vertex: Vertex<T>
    var edges: [Edge<T>]? = nil
    
    init(vertex: Vertex<T>) {
        self.vertex = vertex
        
    }
    
    func addEdge(_ edge: Edge<T>) {
        edges?.append(edge)
        
    }
    
    func removeLastEdge() {
        edges?.removeLast()
    }
}
// graph
open class Graph<T>: CustomStringConvertible where T: Hashable {
    open var description: String {
        fatalError("description: This is abstract class")
    }
    
    open var edges: [Edge<T>] {
        fatalError("edges: This is abstract property")
    }
    
    open var vertices: [Vertex<T>] {
        fatalError("vertices: This is abstract property")
    }
    
    public required init() {}
    public required init(fromGraph graph: Graph<T>) {
        for e in graph.edges {
            let from = createVertex(e.from.data)
            let to = createVertex(e.to.data)
            
            addDirectedEdge(from: from, to: to, withWeight: e.weight!)
        }
    }
    
    open func createVertex(_ data: T) -> Vertex<T> {
        fatalError("createVertex: abstract function")
    }
    
    open func addDirectedEdge(from: Vertex<T>, to: Vertex<T>, withWeight weight: Double) {
        fatalError("addDirectedEdge: abstract function")
    }
    
    open func addUndirectedEdge(vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double) {
        fatalError("addDirectedEdge: abstract function")
    }
    
    open func removeLastDirectedEdge(from: Vertex<T>) {
        fatalError("removeDirectedEdge: abstract function")
    }
    
    
    open func edgesFrom(sourceVertex: Vertex<T>) -> [Edge<T>] {
        fatalError("edgesFrom: abstract function")
    }
    
    open func weightFrom(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        fatalError("weightFrom: abstract function")
    }
    
    
}

// MARK: AdjacencyMatrixGraph<T>

open class AdjacencyMatrixGraph<T>: Graph<T> where T: Hashable {
    fileprivate var adjacencyMatrix: [[Double?]] = []
    fileprivate var _vertices: [Vertex<T>] = []
    
    open override var vertices: [Vertex<T>] {
        //
        return _vertices
    }
    
    open override var edges: [Edge<T>] {
        var edges = [Edge<T>]()
        for row in 0 ..< adjacencyMatrix.count {
            for column in 0 ..< adjacencyMatrix.count {
                if let weight = adjacencyMatrix[row][column]
                {
                    edges.append(Edge(from: vertices[row], to: vertices[column], weight: weight))
                }
            }
        }
        return edges
    }
    
    public required init() {
        super.init()
    }
    
    public required init(fromGraph graph: Graph<T>) {
        super.init(fromGraph: graph)
    }
    
    // MARK: Adja's function
    open override func createVertex(_ data: T) -> Vertex<T> {
        // add a new vertex,
        //if this vertex already exists
        let matchingVertices = vertices.filter {
            vertex in
            return vertex.data == data
        }
        
        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }
        
        //new one @ count
        let vertex = Vertex(data: data, index: adjacencyMatrix.count)
        
        // init
        for i in 0 ..< adjacencyMatrix.count {
            adjacencyMatrix[i].append(nil)
        }
        
        // new row
        let newRow = [Double?](repeating: nil, count: adjacencyMatrix.count + 1)
        adjacencyMatrix.append(newRow)
        
        _vertices.append(vertex)
        
        return vertex
    }
    
    open override func addDirectedEdge(from: Vertex<T>, to: Vertex<T>, withWeight weight: Double) {
        adjacencyMatrix[from.index][to.index] = weight
    }
    
    open override func addUndirectedEdge(vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double) {
        addDirectedEdge(from: vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(from: vertices.1, to: vertices.0, withWeight: weight)
    }
    
    open override func edgesFrom(sourceVertex: Vertex<T>) -> [Edge<T>] {
        var outs = [Edge<T>]()
        let fromIndex = sourceVertex.index
        for col in 0 ..< adjacencyMatrix.count {
            if let weight = adjacencyMatrix[fromIndex][col] {
                outs.append(Edge(from: sourceVertex, to: vertices[col], weight: weight))
            }
        }
        return outs
    }
    
    open override func weightFrom(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        return adjacencyMatrix[sourceVertex.index][destinationVertex.index]
    }
    
    // FOR DEBUG PURPOSE:
    open override var description: String {
        var grid = [String]()
        let n = self.adjacencyMatrix.count
        for i in 0..<n {
            var row = ""
            for j in 0..<n {
                if let value = self.adjacencyMatrix[i][j] {
                    let number = NSString(format: "%.1f", value)
                    row += "\(value >= 0 ? " " : "")\(number) "
                } else {
                    row += "  ø  "
                }
            }
            grid.append(row)
        }
        return (grid as NSArray).componentsJoined(by: "\n")
    }
    
}

// MARK: AdjacencyListGraph
open class AdjacencyListGraph<T>: Graph<T> where T: Hashable {
    //delegate
    var delegate: UpdateGraphStatusDelegate?
    
    fileprivate var adjacencyList: [EdgeList<T>] = []
    
    open override var vertices: [Vertex<T>] {
        var vs = [Vertex<T>] ()
        // get all the vertex mtf
        for edgeList in adjacencyList {
            vs.append(edgeList.vertex)
        }
        return vs
        
    }
    
    open override var edges: [Edge<T>] {
        var allE = Set<Edge<T>>()
        for eL in adjacencyList {
            
            guard let edges = eL.edges else {
                continue
            }
            
            for e in edges {
                allE.insert(e)
            }
        }
        // ina rray form
        return Array(allE)
    }
    
    public required init() {
        super.init()
    }
    
    public required init(fromGraph graph: Graph<T>) {
        super.init(fromGraph: graph)
    }
    
    open override func createVertex(_ data: T) -> Vertex<T> {
        // check
        let match = vertices.filter { v in
            return v.data == data
            
        }
        
        if match.count > 0 {
            return match.last!
        }
        
        // new
        let v = Vertex(data: data, index: adjacencyList.count)
        adjacencyList.append(EdgeList(vertex: v))
        return v
        
    }
    
    open override func addDirectedEdge(from: Vertex<T>, to: Vertex<T>, withWeight weight: Double) {
        let e = Edge(from: from, to: to, weight: weight)
        let edgeList = adjacencyList[from.index]
        if edgeList.edges == nil {
            // this is new one
            // WARNING, nil needed to be removed
            edgeList.edges = [e]
            
        }
        else {
            edgeList.addEdge(e)
        }
    }
    
    open override func removeLastDirectedEdge(from: Vertex<T>) {
        adjacencyList[from.index].removeLastEdge()
    }
    
    open override func addUndirectedEdge(vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double) {
        addDirectedEdge(from: vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(from: vertices.0, to: vertices.1, withWeight: weight)
    }
    
    
    
    open override func edgesFrom(sourceVertex: Vertex<T>) -> [Edge<T>] {
        return adjacencyList[sourceVertex.index].edges ?? []
    }
    
    open override func weightFrom(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        guard let edges = adjacencyList[sourceVertex.index].edges else {
            return nil
        }
        
        for e: Edge<T> in edges {
            if e.to == destinationVertex {
                return e.weight
            }
        }
        return nil
    }
    
   
    // MARK: Debug purpose
    open override var description: String {
        var rows = [String]()
        for edgeList in adjacencyList {
            
            guard let edges = edgeList.edges else {
                continue
            }
            
            var row = [String]()
            for edge in edges {
                var value = "\(edge.to.data)"
                if edge.weight != nil {
                    value = "(\(value): \(edge.weight!))"
                }
                row.append(value)
            }
            
            rows.append("\(edgeList.vertex.data) -> [\(row.joined(separator: ", "))]")
        }
        
        return rows.joined(separator: "\n")
    }
    
    
    //  Search
    
    // BFS
    public func bfs(source: Vertex<T>)-> [Vertex<T>] {
        var q = Queue<Vertex<T>>()
        q.enqueue(source)
        
        var nodesExplored = [source]
        var visited = [source]
        
        delegate?.updateVertexPosition(at: source.index)
        delegate?.updateExplored(at: source.index)
      
        while let c = q.dequeue() {
            
            delegate?.updateVertexPosition(at: c.index)
            for edge in edgesFrom(sourceVertex: c) {
                let neighbor = edge.to
                
                if !visited.contains(neighbor) {
                    q.enqueue(neighbor)
                    visited.append(neighbor)
                    nodesExplored.append(neighbor)
                    delegate?.updateExplored(at: neighbor.index)
                    delegate?.updateVertexPosition(at: neighbor.index)
                }
                delegate?.updateVertexPosition(at: c.index)
            }

        }
        
        return nodesExplored
    }
    
    
    
    // DFS
    /*
     lexi
     1  procedure DFS(G,v):
     2      label v as discovered
     3      for all edges from v to w in G.adjacentEdges(v) do
     4          if vertex w is not labeled as discovered then
     5              recursively call DFS(G,w)
     */
    public func dfs_lexi(source: Vertex<T>) -> [Vertex<T>] {
        var nodesExplores = [source]
        source.visited = true
        
        // Update UI
        delegate?.updateExplored(at: source.index)
        delegate?.updateVertexPosition(at: source.index)
        
        
        for e in edgesFrom(sourceVertex: source) {
            if !(e.to.visited) {
                nodesExplores += dfs_lexi(source: e.to)
                delegate?.updateVertexPosition(at: source.index)
            }
        }
        
        return nodesExplores
    }
    /* Non-lexi
     1  procedure DFS-iterative(G,v):
     2      let S be a stack
     3      S.push(v)
     4      while S is not empty
     5          v = S.pop()
     6          if v is not labeled as discovered:
     7              label v as discovered
     8              for all edges from v to w in G.adjacentEdges(v) do
     9                  S.push(w)
     */
    public func dfs_nonlexi(source: Vertex<T>) -> [Vertex<T>] {
        var nodesExplores = [Vertex<T>]()
        var visited = [Vertex<T>]()
        var s = Stack<Vertex<T>>()
        s.put(source)

        while !s.isEmpty {
            var v = s.pop()
            if !visited.contains(v!) {
                let vIndex = visited.count
                
                delegate?.updateExplored(at: v!.index)
                delegate?.updateVertexPosition(at: v!.index)
                visited.append(v!)
                for e in edgesFrom(sourceVertex: v!) {
                    print("Edge")
                    if !visited.contains(e.to) {
                        s.put(e.to)

                    }
                    
                }
                if !nodesExplores.isEmpty {
                    delegate?.updateVertexPosition(at: nodesExplores.last!.index)
                }
                nodesExplores.append(v!)
                
            }
            
        }

        return nodesExplores
    }
    
    // Dijkstra
    public func dijkstra(source: Vertex<T>) {
        var q = Set<Vertex<T>>()
        
        for i in 0 ..< vertices.count {
            vertices[i].visited = false
            vertices[i].prev = nil
            vertices[i].dist = Double.infinity
            q.insert(vertices[i])
        }
        
        source.dist = 0 // distance from source to source
        delegate?.updateExplored(at: source.index)
        delegate?.updateVertexPosition(at: source.index)

        
        while !q.isEmpty {
            let ut = q.min {$0.dist < $1.dist }// vertex with min dist , remove
            q.remove(ut!)
            if let u = ut {
                for e in edgesFrom(sourceVertex: u) {
                    var v = e.to
                    let alt = u.dist + e.weight!
                    delegate?.updateExplored(at: v.index)
                    delegate?.updateVertexPosition(at: v.index)

                    
                    // FIXME: update route
                    if alt < v.dist {
                        v.dist = alt
                        v.prev = u
                    }
                }
            }
        }

        // return
    }
    
    // TLS
    public func topologicalSort() -> [Vertex<T>]{
        var stack = Stack<Vertex<T>>()
        
        var visited = [Int: Bool]()
        for i in 0 ..< vertices.count {
            visited[i] = false
        }
        
        func innerdfs(_ source: Vertex<T>) {
            let es = self.edgesFrom(sourceVertex: source)
            for e in es {
                if !visited[e.to.index]! {
                    innerdfs(e.to)
                }
            }
            stack.put(source)
            visited[source.index] = true
        }
        
        for v in vertices {
            if !visited[v.index]! {
                innerdfs(v)
            }
        }
        
        return stack.reverse()
    }
    
    public func stronglyConnected() -> Bool {
        // mark all vertices not visited
        var disc: [Int] = []
        // earliest visited vertex
        var low: [Int] = []
        // check if it's in stack
        var visited: [Bool] = []
        // store all possible connected ancestors
        var stack: [Vertex<T>] = []
        
        for _ in 0 ..< vertices.count {
            disc.append(-1)
            low.append(-1)
            visited.append(false)
        }
        
        
        for i in 0 ..< vertices.count {
            if (disc[i] == -1) {
                let connected: Bool = stronglyConnected(source: vertices[i], disc: &disc, low: &low, visited: &visited, stack: &stack, index: i)
                if connected {
                    return connected
                }
            }
        }
        
        return false
        
    }
    private func stronglyConnected(source: Vertex<T>, disc: inout [Int], low: inout [Int], visited:inout [Bool], stack: inout [Vertex<T>], index: Int) -> Bool {
        let nIndex = source.index
        disc[nIndex] = index
        low[nIndex] = index
        
        visited[nIndex] = true
        stack.append(source)
        for e in edgesFrom(sourceVertex: source) {
            if (disc[e.to.index] == -1) {
                let connected: Bool = stronglyConnected(source: e.to, disc: &disc, low: &low, visited: &visited, stack: &stack, index: index + 1)
                
                // stop if we found connected
                if connected {
                    return connected
                }
                // check if v's subtree has a connection to source
                low[nIndex] = min(low[nIndex], low[e.to.index])
            }
            else if (visited[e.to.index]) {
            
                low[nIndex] = min(low[nIndex], disc[e.to.index])
            }
        }
        var wIndex = -1
        var counter = 0
        // root node
        if low[nIndex] == disc[nIndex] {
  
            while wIndex != nIndex {
                wIndex = stack.removeLast().index
           
                visited[wIndex] = false
                counter += 1
            }
            if counter > 1 {
                return true
            }
        }
        return false
    }
}


