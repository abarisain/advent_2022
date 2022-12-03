import Foundation

struct ElfGroup {
    let bags: [Substring]
    
    var duplicateLetter: Character? {
        get {
            var mutableBags = bags
            var intersection = Set(mutableBags.removeFirst())
            
            for bag in mutableBags {
                intersection = intersection.intersection(Set(bag))
            }

            if intersection.count != 1 {
                fatalError("multiple or no intersections")
            }
            return intersection.first
        }
    }
}

func run2() {
    print("2:")
    
    var bags = input.split(separator: "\n")
    
    var elfGroups = [ElfGroup]()
    while bags.count > 0 {
        let groupBags = bags.prefix(3)
        elfGroups.append(ElfGroup(bags: Array(groupBags)))
        bags.removeFirst(3)
    }
    
    let duplicates = elfGroups.map { $0.duplicateLetter }.compactMap { $0 }
    
    let sum = duplicates.map { priorityTable[$0]! }.reduce(0, +)
    
    print(sum)
    
    print("Done")
}
