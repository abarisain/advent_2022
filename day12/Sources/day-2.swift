import Foundation

// Path finder that search for the lowest point from the top
// We can easily to this by making the destination be the start
// and reverse the climb condition
class FloorPathFinder: PathFinder {
    
    override init(input: String) {
        super.init(input: input)
        start = destination
    }
    
    override func canReach(node: Node, from: Node) -> Bool {
        // Reverse the condition as we start from the top
        // We can climb to infinite heights, but can only drop 1 or more
        return Int(from.item.height) - Int(node.item.height) <= 1
    }
    
    override func reachedDestination(currentNode: Node) -> Bool {
        return currentNode.item.height == 0
    }
}

func run2() {
    useSampleInput = false
    print("2:")
    
    print("1:")
       
    let pathFinder = FloorPathFinder(input: input)
    //pathFinder.printGrid()
    let answer = pathFinder.walk()
    
    print("Answer: \(answer)")
    
    print("Done")
}
