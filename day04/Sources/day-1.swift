import Foundation

func parseRange(_ input: Substring) -> CountableClosedRange<Int> {
    let split = input.split(separator: "-")
    let left = Int(split[0])!
    let right = Int(split[1])!
    return left...right
}

struct Pair {
    let first: CountableClosedRange<Int>
    let second: CountableClosedRange<Int>
    
    var hasCompleteOverlap: Bool {
        get {
            let firstSet = Set(first)
            let secondSet = Set(second)
            return firstSet.isSubset(of: secondSet) || secondSet.isSubset(of: firstSet)
        }
    }
    
    init(input: Substring) {
        let split = input.split(separator: ",")
        self.first = parseRange(split[0])
        self.second = parseRange(split[1])
    }
}

func run1() {
    print("1:")
    
    let input = input.split(separator: "\n")
    let pairs = input.map { Pair(input: $0) }
    let overlapping = pairs.map { $0.hasCompleteOverlap }.filter { $0 == true }
    let sum = overlapping.count
    
    print("Sum: \(sum)")
    print("Done")
}
