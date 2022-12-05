import Foundation

func prepareInput() -> (String, [String]) {
    let split = input.split(separator: "\n\n")
    return (String(split[0]), split[1].split(separator: "\n").map { String($0) })
}

func parseStacks(_ rawStacks: String) -> [[Character]] {
    let splitRawStacks = rawStacks.split(separator: "\n", omittingEmptySubsequences: false).dropLast(1).map { String($0) }
    let stacksCount = (splitRawStacks[0].count+1)/4
    
    var stacks = [[Character]]()
    for i in 1...stacksCount {
        var stack = [Character]()
        let stackIndex = i*4-2
        splitRawStacks.forEach { rawStack in
            let item: Character = rawStack[rawStack.index(rawStack.startIndex, offsetBy: stackIndex-1)]
            if item != " " {
                stack.insert(item, at: 0)
            }
        }
        stacks.append(stack)
    }
    return stacks
}

struct Move {
    let howMany: Int
    let from: Int
    let to: Int
    
    init(fromRawMove rawMove: String) {
        let split = rawMove.split(separator: " ")
        howMany = Int(split[1])!
        from = Int(split[3])!
        to = Int(split[5])!
    }
}

func run1() {
    print("1:")
    
    let (rawStacks, rawMoves) = prepareInput()
    
    let moves = rawMoves.map { Move(fromRawMove: $0) }
    
    var stacks = parseStacks(rawStacks)
    
    for move in moves {
        var from = stacks[move.from-1]
        var to = stacks[move.to-1]
        for _ in 1...move.howMany {
            to.append(from.removeLast())
        }
        stacks[move.from-1] = from
        stacks[move.to-1] = to
    }
    
    var answer = ""
    for stack in stacks {
        answer += String(stack.last ?? Character(""))
    }
    
    print("Answer: \(answer)")
    print("Done")
}
