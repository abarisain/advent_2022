import Foundation

func computeScenicScore(in grid: Grid, row: Int, column: Int) -> Int {
    let treeHeight = grid[row, column]!
    var visibleTrees = [Int]()
    
    visibleTrees.append(countVisibleTrees(treeHeight, trees: grid.walkTopOf(row: row, column: column)))
    visibleTrees.append(countVisibleTrees(treeHeight, trees: grid.walkBottomOf(row: row, column: column)))
    visibleTrees.append(countVisibleTrees(treeHeight, trees: grid.walkLeftOf(row: row, column: column)))
    visibleTrees.append(countVisibleTrees(treeHeight, trees: grid.walkRightOf(row: row, column: column)))

    return visibleTrees.filter { $0 > 0 }.reduce(1, *)
}

func countVisibleTrees(_ currentTreeHeight: Int, trees: [Int]) -> Int {
    var visibleTrees = 0
    for distantTreeHeight in trees {
        visibleTrees += 1
        if distantTreeHeight >= currentTreeHeight {
            break
        }
    }
    return visibleTrees
}

func run2() {
    useSampleInput = false
    print("2:")
    
    let length = input.firstIndex(of: "\n")!.utf16Offset(in: input)
    let intInput: [Int] = Array(input).filter { $0 != "\n" }.map { Int(String($0))! }
    
    let grid = Grid(from: intInput, rowLength: length)
    
    var scenicScores = [Int]()
    for row in 0..<grid.rows {
        for column in 0..<grid.columns {
            scenicScores.append(computeScenicScore(in: grid, row: row, column: column))
        }
    }
    
    let best = scenicScores.sorted(by: >).first!
    
    print("Best score: \(best)")
    
    print("Done")
}
