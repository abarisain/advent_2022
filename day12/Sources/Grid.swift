import Foundation

struct Grid<T> {
    typealias Item = T
    
    let rowLength: Int
    
    var backingArray: [Item]
    
    init(from: [Item], rowLength: Int) {
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
    
    subscript(safe index: Int) -> Item? {
        if index < 0 || index >= backingArray.count {
            return nil
        }
        return backingArray[index]
    }
    
    subscript(row: Int, column: Int) -> Item? {
        if (row < 0 || column < 0 || column >= columns) {
            return nil
        }
        return self[safe: (row * rowLength) + column]
    }
}

