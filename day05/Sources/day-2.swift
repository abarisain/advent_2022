import Foundation

func run2() {
    print("2:")
    
    let (rawStacks, rawMoves) = prepareInput()
    
    let moves = rawMoves.map { Move(fromRawMove: $0) }
    
    var stacks = parseStacks(rawStacks)
    
    for move in moves {
        var from = stacks[move.from-1]
        var to = stacks[move.to-1]
        var tmpStack = [Character]()
        for _ in 1...move.howMany {
            tmpStack.insert(from.removeLast(), at: 0)
        }
        to.append(contentsOf: tmpStack)
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
