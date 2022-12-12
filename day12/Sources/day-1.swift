import Foundation

let alphabet = "abcdefghijklmnopqrstuvwxyz"

struct Position: Hashable {
    let row: Int
    let column: Int
}

struct MapItem {
    let height: UInt
    let isBestSignalLocation: Bool
    let debugRepresentation: Character
    
    static func from(input: Character) -> MapItem {
        if input == "E" {
            return MapItem(height: 25, isBestSignalLocation: true, debugRepresentation: input)
        }
        if input == "S" {
            return MapItem(height: 0, isBestSignalLocation: false, debugRepresentation: input)
        }
        
        if let letterIndex = alphabet.firstIndex(of: input) {
            let index = alphabet.distance(from: alphabet.startIndex, to: letterIndex)
            return MapItem(height: UInt(index), isBestSignalLocation: false, debugRepresentation: input)
        }
        
        fatalError("Unknown height: \(input)")
    }
}

struct Node: Hashable {
    let item: MapItem
    let position: Position
    var tentativeDistance: Int = Int.max
    
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
    let gridHeight: Int
    let gridWidth: Int
    
    init(nodes: [Position: Node], gridHeight: Int, gridWidth: Int) {
        allNodes = nodes
        unvisitedPositions = Set(nodes.keys)
        self.gridHeight = gridHeight
        self.gridWidth = gridWidth
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

func run1() {
    useSampleInput = true
    print("1:")
       
    var pathFinder = PathFinder.from(input: input)
    pathFinder.printGrid()
    
    print("Done")
}
