import Foundation

struct LimitedSizeQueue<T> {
    typealias Element = T
    
    let size: UInt
    
    var backingArray = [T]()
    
    init(size: UInt) {
        self.size = size
    }
    
    mutating func push(_ item: T) {
        backingArray.append(item)
        if backingArray.count > size {
            backingArray.removeFirst()
        }
    }
}

var MARKER_LENGTH: UInt = 0

extension LimitedSizeQueue where Element == Character {
    var isMarker: Bool {
        get {
            if backingArray.count != MARKER_LENGTH {
                return false
            }
            if Set(backingArray).count == MARKER_LENGTH {
                return true
            }
            return false
        }
    }
}

func findMarker() -> Int {
    var commsQueue = LimitedSizeQueue<Character>(size: MARKER_LENGTH)
    var counter = 0
    for char in input {
        counter += 1
        commsQueue.push(char)
        if commsQueue.isMarker {
            return counter
        }
    }
    fatalError("Could not find marker")
}

func run1() {
    useSampleInput = false
    print("1:")
    
    MARKER_LENGTH = 4
    
    let position = findMarker()
    print("Position: \(position)")
    
    print("Done")
}
