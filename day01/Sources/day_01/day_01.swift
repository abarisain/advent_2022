import Foundation

let sourceDataURL = URL(string: "file:///Users/arnaud/dev/github/abarisain/advent_2022/day_01/input.txt")!

@available(macOS 13.0, *)
@main
public struct day_01 {
    public private(set) var text = "Hello, World!"

    @available(macOS 13.0, *)
    public static func main() {
        let input = try! String(contentsOf: sourceDataURL, encoding: .ascii)
        let splitted = input.split(separator: "\n", omittingEmptySubsequences: false)
        
        var initialElves = [[Int]]()
        initialElves.append([])
        
        let grouped = splitted.reduce(initialElves) { partialResult, value in
            var elves = partialResult
            if (value == "") {
                elves.append([])
            } else {
                var carrying = elves.removeLast()
                carrying.append(Int(value)!)
                elves.append(carrying)
            }
            return elves
        }
        
        let reduced = grouped.reduce([Int]()) { partialResult, carrying in
            var elves = partialResult
            elves.append(carrying.reduce(0) { x, y in
                x + y
            })
            return elves
        }
        
        let sorted = reduced.sorted(by: >)
        
        let max = sorted.first!
        let top3 = sorted[0] + sorted[1] + sorted[2]
        
        print("Done! Max: \(max), sum of top 3: \(top3)")
    }
}
