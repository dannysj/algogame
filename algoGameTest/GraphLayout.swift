//
//  GraphLayout.swift
//  algoGameTest
//
//  Created by Danny Chew on 3/27/18.
//  Copyright © 2018 Danny Chew. All rights reserved.
//

import Foundation

// Topological sort
public class SimpleGraph2: CustomStringConvertible {
    // in this case we treat each node as "String"
    public typealias Node = String
    private(set) public var adjList: [Node: [Node]]
    public var description: String {
        return adjList.description
    }
    
    public init() {
        adjList = [Node: [Node]]()
    }
    
    public func addNode(_ value: Node) -> Node {
        adjList[value] = []
        return value
    }
    
    public func addEdge(from: Node, to: Node) -> Bool {
        adjList[from]?.append(to)
        return adjList[from] != nil ? true : false
    }
    
    //return a list of nodes (neighbors)
    public func adjacencyList(node: Node)-> [Node]? {
        for (k, adjacencyList) in adjList {
            if k == node {
                return adjacencyList
            }
        }
        return nil
    }
    
}

extension SimpleGraph2 {
    public func topologicalSort() -> [Node] {
        var stack = [Node]()
        
        var visited = [Node:Bool]()
        
        for (n, _) in adjList {
            visited[n] = false
        }
        
        var order = [Node]()
        
        func dfs(source: Node) {
            if let adj = adjacencyList(node: source) {
                for neighbor in adj {
                    if let seen = visited[neighbor], !seen {
                        dfs(source: neighbor)
                    }
                }
            }
            
            // completed, we know that this is last
            stack.append(source)
            visited[source] = true
        }
        
        //while !stack.isEmpty {
        //    var c = stack.last!
        //    var nodes = adjacencyList(node: c)
            // if all successors of c are visited
            for (node, _) in visited {
                if let seen = visited[node] , !seen {
                    dfs(source: node)
                }
            }
    /*        if test.is
                stack.remove(at: stack.count - 1)
                order.append(c)
            // else
                //select an unvisietd successor of c
                visited.append(<#T##newElement: Vertex<Hashable>##Vertex<Hashable>#>)
                stack.append(<#T##newElement: Vertex<Hashable>##Vertex<Hashable>#>)
        }
        return order.reversed()
 */
        return stack.reversed()
    }
    
    // bfs
    func bfs(source: Node)-> [Node] {
        var q = Queue<Node>()
        q.enqueue(source)
        
        while let c = q.dequeue() {
            for e in adjacencyList(node: c)! {
                let neighborNode = adjacencyList(node: e)
            }
        }
    }
    // dfs
    
    // Dijkstra
    
}


