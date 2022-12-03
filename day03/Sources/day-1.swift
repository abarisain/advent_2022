import Foundation

//MARK: Priority
let alphabet = "abcdefghijklmnopqrstuvwxyz"

func makePriorityTable() -> [Character: Int] {
    let fullAlphabet = "\(alphabet)\(alphabet.uppercased(with: Locale(identifier: "en-US")))"
    
    var table = [Character: Int]()
    var counter = 0
    
    fullAlphabet.forEach { char in
        counter += 1
        table[char] = counter
    }
    return table
}

let priorityTable = makePriorityTable()

//MARK: Structs

struct Bag {
    let first: Substring
    let second: Substring
    
    init(contents: Substring) {
        let half = (contents.count/2)
        first = contents.dropLast(half)
        second = contents.dropFirst(half)
        if (first.count != second.count) {
            fatalError("uneven bags")
        }
        //print("\(contents) \(first)__\(second)")
    }
    
    var duplicateLetter: Character? {
        get {
            let firstChars = Set(first)
            let secondChars = Set(second)
            let intersection = firstChars.intersection(secondChars)
            if intersection.count != 1 {
                fatalError("multiple intersections")
            }
            return intersection.first
        }
    }
}

func run1() {
    print("1:")
    
    let bags = input.split(separator: "\n").map { Bag(contents: $0) }
    
    let duplicates = bags.map { $0.duplicateLetter }.compactMap { $0 }
    
    let sum = duplicates.map { priorityTable[$0]! }.reduce(0, +)
    
    print(sum)
    
    print("Done")
}
