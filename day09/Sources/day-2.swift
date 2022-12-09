import Foundation

let largerSampleInput = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

func printBoard2() {
    let min = -5
    let max = 5
    
    print("----- Board -----")
    for row in min...max {
        var line = ""
        for col in min...max {
            
            let printPos = Position(row: row, column: col)
            var found = false
            for i in 0..<ropeFragments.count {
                if ropeFragments[i] == printPos {
                    if i == 0 {
                        line += "H"
                    } else {
                        line += "\(i)"
                    }
                    found = true
                    break
                }
            }
            if !found {
                if col == 0 && row == 0 {
                    line += "s"
                } else {
                    line += "."
                }
            }
        }
        print(line)
    }
    print("-----------------")
}

var ropeFragments: [Position] = Array(repeating: Position(row: 0, column: 0), count: 10)

func run2() {
    useSampleInput = false
    //input = largerSampleInput
    verbose = false
    print("2:")
    visitedPositions = Set<Position>()
    headPosition = Position(row: 0, column: 0)
    tailPosition = Position(row: 0, column: 0)
    
    let moves = parseMoves()
    
    for move in moves {
        for _ in 1...move.howMany {
            ropeFragments[0].move(move.direction)
            for i in 1..<ropeFragments.count {
                let trailingMoves = computeTailMoves(head: ropeFragments[i-1], tail: ropeFragments[i])
                for trailingMove in trailingMoves {
                    ropeFragments[i].move(trailingMove)
                }
            }
            if verbose {
                printBoard2()
            }
            visitedPositions.insert(ropeFragments.last!)
        }
    }
    
    print("Visited positions: \(visitedPositions.count)")
    
    print("Done")
}
