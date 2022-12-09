import Foundation

var verbose = true

struct Position: Hashable {
    var row: Int
    var column: Int
    
    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    mutating func move(_ direction: Direction) {
        switch direction {
            case .up:
                row -= 1
            case .down:
                row += 1
            case .left:
                column -= 1
            case .right:
                column += 1
        }
    }
    
    func moving(_ direction: Direction) -> Position {
        var newPos = self
        newPos.move(direction)
        return newPos
    }
}

struct Move {
    let direction: Direction
    let howMany: Int
    
    init(from input: String) {
        let split = input.split(separator: " ")
        direction = Direction.from(input: split[0].first!)
        howMany = Int(split[1])!
    }
}

enum Direction {
    case up
    case down
    case left
    case right
    
    static func from(input: Character) -> Direction {
        switch input {
            case "U":
                return .up
            case "D":
                return .down
            case "L":
                return .left
            case "R":
                return .right
            default:
                fatalError("Unknown direction: \(input)")
        }
    }
}

func parseMoves() -> [Move] {
    return input.split(separator: "\n").map { Move(from: String($0)) }
}

// Compute which moves the tail needs to make to keep up with the head, if any
func computeTailMoves(head: Position, tail: Position) -> [Direction] {
    if head == tail {
        if verbose {
            print("Tail is stacked on top of head")
        }
        return []
    }
    let rowDistance = tail.row - head.row
    let columnDistance = tail.column - head.column
    if verbose {
        print("Distance with tail: row \(rowDistance) - col \(columnDistance)")
    }
    
    if abs(rowDistance) > 2 || abs(columnDistance) > 2 {
        fatalError("Distance between head and tail is > 2, something went wrong: row \(rowDistance) - col \(columnDistance)")
    }
    
    if abs(rowDistance) < 2 && abs(columnDistance) < 2 {
        return []
    }
    
    var out = [Direction]()

    var movedRow = false
    var movedCol = false
    
    func moveRow() {
        if movedRow {
            return
        }
        movedRow = true
        if rowDistance < 0 {
            // Negative row, we're higher
            out.append(.down)
        } else {
            // Positive row, we're below
            out.append(.up)
        }
    }
    
    func moveCol() {
        if movedCol {
            return
        }
        movedCol = true
        if columnDistance < 0 {
            // Negative column, we're on the left
            out.append(.right)
        } else {
            // Positive column, we're on the right
            out.append(.left)
        }
    }
    
    if abs(rowDistance) > 1 {
        moveRow()
        if columnDistance != 0 {
            moveCol()
        }
    }
    
    if abs(columnDistance) > 1 {
        moveCol()
        if rowDistance != 0 {
            moveRow()
        }
    }
    
    return out
}

func printBoardHistory(visitedPositions: Set<Position>) {
    let minRow = visitedPositions.map { $0.row }.min()!
    let maxRow = visitedPositions.map { $0.row }.max()!
    let minCol = visitedPositions.map { $0.column }.min()!
    let maxCol = visitedPositions.map { $0.column }.max()!
    
    print("----- Board History -----")
    for row in minRow...maxRow {
        var line = ""
        for col in minCol...maxCol {
            if col == 0 && row == 0 {
                line += "s"
                continue
            }
            if visitedPositions.contains(Position(row: row, column: col)) {
                line += "#"
            } else {
                line += "."
            }
        }
        print(line)
    }
    print("-------------------------")
}

func printBoard() {
    let min = -5
    let max = 5
    let head = headPosition
    let tail = tailPosition
    
    print("----- Board -----")
    for row in min...max {
        var line = ""
        for col in min...max {
            if col == 0 && row == 0 {
                line += "s"
                continue
            }
            let printPos = Position(row: row, column: col)
            if head == printPos {
                line += "H"
            } else if tail == printPos {
                line += "T"
            } else {
                line += "."
            }
        }
        print(line)
    }
    print("-----------------")
}

var visitedPositions = Set<Position>()
var headPosition = Position(row: 0, column: 0)
var tailPosition = Position(row: 0, column: 0)

func run1() {
    useSampleInput = false
    print("1:")
    
    let moves = parseMoves()
    
    visitedPositions.insert(tailPosition)
    
    for move in moves {
        for _ in 1...move.howMany {
            headPosition.move(move.direction)
            if verbose {
                print("Move: \(String(describing: move.direction))")
                print("New head: \(String(describing: headPosition))")
                print("Tail: \(String(describing: tailPosition))")
            }
            let tailMoves = computeTailMoves(head: headPosition, tail: tailPosition)
            if verbose {
                print("Tail moves: \(tailMoves.map { String(describing: $0) }.joined(separator: ","))")
            }
            for tailMove in tailMoves {
                tailPosition.move(tailMove)
            }
            if verbose {
                print("Moved tail")
            }
            assert(computeTailMoves(head: headPosition, tail: tailPosition).count == 0)
            visitedPositions.insert(tailPosition)
            
            if verbose {
                print("New tail: \(String(describing: tailPosition))")
                print("-----------")
                printBoard()
            }
        }
    }
    
    printBoardHistory(visitedPositions: visitedPositions)
    
    assert(visitedPositions.count == (useSampleInput ? 13 : 6486))
    
    print("Visited positions: \(visitedPositions.count)")
    
    print("Done")
}
