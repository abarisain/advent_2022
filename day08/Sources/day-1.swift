import Foundation

struct Grid {
    let rowLength: Int
    
    var backingArray: [Int]
    
    init(from: [Int], rowLength: Int) {
        self.rowLength = rowLength
        backingArray = from
    }
    
    var count: Int {
        backingArray.count
    }
    
    var rows: Int {
        return count/rowLength
    }
    
    var columns: Int {
        return rowLength
    }
    
    subscript(safe index: Int) -> Int? {
        if index < 0 || index >= backingArray.count {
            return nil
        }
        return backingArray[index]
    }
    
    subscript(row: Int, column: Int) -> Int? {
        if (row < 0 || column < 0 || column >= columns) {
            return nil
        }
        return self[safe: (row * rowLength) + column]
    }
}

extension Grid {
    func walkTopOf(row: Int, column: Int) -> [Int] {
        var out = [Int]()
        var i = row-1
        while let tree = self[i, column] {
            out.append(tree)
            i -= 1
        }
        return out
    }
    
    func walkBottomOf(row: Int, column: Int) -> [Int] {
        var out = [Int]()
        var i = row+1
        while let tree = self[i, column] {
            out.append(tree)
            i += 1
        }
        return out
    }
    
    func walkLeftOf(row: Int, column: Int) -> [Int] {
        var out = [Int]()
        var i = column-1
        while let tree = self[row, i] {
            out.append(tree)
            i -= 1
        }
        return out
    }
    
    func walkRightOf(row: Int, column: Int) -> [Int] {
        var out = [Int]()
        var i = column+1
        while let tree = self[row, i] {
            out.append(tree)
            i += 1
        }
        return out
    }
}

func isTreeVisible(in grid: Grid, row: Int, column: Int) -> Bool {
    let treeHeight = grid[row, column]!
    if isTreeVisibleWithOtherTrees(treeHeight, trees: grid.walkTopOf(row: row, column: column)) {
        return true
    }
    if isTreeVisibleWithOtherTrees(treeHeight, trees: grid.walkBottomOf(row: row, column: column)) {
        return true
    }
    if isTreeVisibleWithOtherTrees(treeHeight, trees: grid.walkLeftOf(row: row, column: column)) {
        return true
    }
    if isTreeVisibleWithOtherTrees(treeHeight, trees: grid.walkRightOf(row: row, column: column)) {
        return true
    }
    return false
}

func isTreeVisibleWithOtherTrees(_ treeHeight: Int, trees: [Int]) -> Bool {
    if let highestTree = trees.max() {
        return treeHeight > highestTree
    }
    return true
}

func run1() {
    useSampleInput = false
    print("1:")
    
    let length = input.firstIndex(of: "\n")!.utf16Offset(in: input)
    let intInput: [Int] = Array(input).filter { $0 != "\n" }.map { Int(String($0))! }
    
    let grid = Grid(from: intInput, rowLength: length)
    
    var visibleTrees = 0
    for row in 0..<grid.rows {
        for column in 0..<grid.columns {
            let visible = isTreeVisible(in: grid, row: row, column: column)
            if visible {
                visibleTrees += 1
            }
            print("\(row), \(column) : \(visible)")
        }
    }
    
    print("Visible trees: \(visibleTrees)")
    
    print("Done")
}
