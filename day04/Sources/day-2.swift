import Foundation

extension Pair {
    var hasOverlap: Bool {
        get {
            let firstSet = Set(first)
            let secondSet = Set(second)
            return firstSet.intersection(secondSet).count > 0
        }
    }
}

func run2() {
    print("2:")
    
    let input = input.split(separator: "\n")
    let pairs = input.map { Pair(input: $0) }
    let overlapping = pairs.map { $0.hasOverlap }.filter { $0 == true }
    let sum = overlapping.count
    
    print("Sum: \(sum)")
    print("Done")
}
