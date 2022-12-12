import Foundation

let alphabet = "abcdefghijklmnopqrstuvwxyz"

struct Position: Hashable {
    let row: Int
    let column: Int
}

struct MapItem {
    let height: UInt
    let isStart: Bool
    let isBestSignalLocation: Bool
    let debugRepresentation: Character
    
    static func from(input: Character) -> MapItem {
        if input == "E" {
            return MapItem(height: 25, isStart: false, isBestSignalLocation: true, debugRepresentation: input)
        }
        if input == "S" {
            return MapItem(height: 0, isStart: true, isBestSignalLocation: false, debugRepresentation: input)
        }
        
        if let letterIndex = alphabet.firstIndex(of: input) {
            let index = alphabet.distance(from: alphabet.startIndex, to: letterIndex)
            return MapItem(height: UInt(index), isStart: false, isBestSignalLocation: false, debugRepresentation: input)
        }
        
        fatalError("Unknown height: \(input)")
    }
}

class Node: Hashable {
    let item: MapItem
    let position: Position
    var tentativeDistance: Int = Int.max
    
    init(item: MapItem, position: Position) {
        self.item = item
        self.position = position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
    
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.position == rhs.position
    }
}

class PathFinder {
    var unvisitedPositions: Set<Position>
    var allNodes = [Position: Node]()
    let start: Position
    let destination: Position
    let gridHeight: Int
    let gridWidth: Int
    
    init(nodes: [Position: Node], gridHeight: Int, gridWidth: Int) {
        allNodes = nodes
        self.gridHeight = gridHeight
        self.gridWidth = gridWidth
        start = allNodes.values.filter { $0.item.isStart }.first!.position
        destination = allNodes.values.filter { $0.item.isBestSignalLocation }.first!.position
        unvisitedPositions = Set()
        reset()
    }
    
    func reset() {
        unvisitedPositions = Set(allNodes.keys)
        
        allNodes.values.forEach { node in
            if node.position == start {
                node.tentativeDistance = 0
            } else {
                node.tentativeDistance = Int.max
            }
        }
    }
    
    static func from(input: String) -> PathFinder {
        var tmpNodes = [Position: Node]()
        
        let lines = input.split(separator: "\n").map { line in
            line.map { MapItem.from(input: $0) }
        }
        lines.indices.forEach { row in
            let line = lines[row]
            line.indices.forEach { column in
                let position = Position(row: row, column: column)
                tmpNodes[position] = Node(item: line[column], position: position)
            }
        }
        
        return PathFinder(nodes: tmpNodes, gridHeight: lines.count, gridWidth: lines[0].count)
    }
    
    func printGrid() {
        print("")
        for row in 0..<gridHeight {
            for column in 0..<gridWidth {
                let item = allNodes[Position(row: row, column: column)]?.item
                print(item!.debugRepresentation, terminator: "")
            }
            print("")
        }
        print("")
    }
}

//MARK: Algorithm

extension PathFinder {
    func unvisitedNeighbors(for root: Position) -> [Position] {
        var out = [Position]()
        for rowOffset in -1...1 {
            for columnOffset in -1...1 {
                // Skip diagonals
                if abs(rowOffset) == abs(columnOffset) {
                    continue
                }
                let neighbor = Position(row: root.row + rowOffset, column: root.column + columnOffset)
                if allNodes.keys.contains(neighbor) {
                    out.append(neighbor)
                }
            }
        }
        return out
    }
    
    func walk() -> Int {
        reset()
        print("Starting point \(start)")
        print("Destination \(destination)")
        var currentNode = allNodes[start]!
        
        while true {
            if unvisitedPositions.isEmpty {
                fatalError("Visited all positions")
            }
            
            let unvisitedNodes = unvisitedPositions
                .map { allNodes[$0]! }
            let sortedUnvisitedNodes = unvisitedNodes.sorted { $0.tentativeDistance < $1.tentativeDistance }
            currentNode = sortedUnvisitedNodes.first!
            
            // Filter out neightbors that we can't climb to
            let neighbors = unvisitedNeighbors(for: currentNode.position)
                .map { allNodes[$0]! }
                .filter { $0.item.height <= (currentNode.item.height + 1) }
            for neighbor in neighbors {
                if currentNode.tentativeDistance < Int.max {
                    let newTentativeDistance = currentNode.tentativeDistance + 1
                    neighbor.tentativeDistance = min(newTentativeDistance, neighbor.tentativeDistance)
                }
            }
            unvisitedPositions.remove(currentNode.position)
            
            // Did we just visit the target node
            if currentNode.item.isBestSignalLocation {
                print("Visited best signal! Distance: \(currentNode.tentativeDistance)")
                print("Unvisited squares: \(unvisitedPositions.count)")
                return currentNode.tentativeDistance
            }
        }
        
    }
}

func run1() {
    useSampleInput = false
    print("1:")
       
    let pathFinder = PathFinder.from(input: input)
    //pathFinder.printGrid()
    let answer = pathFinder.walk()
    
    print("Answer: \(answer)")
    print("Done")
}
