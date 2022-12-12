import Foundation

func printInspectedItems(round: Int, monkeys: [Monkey]) {
    print("=====================")
    print("Round n°\(round)")
    let inspectedItems = monkeys.map { $0.inspectedItems }
    
    inspectedItems.indices.forEach { i in
        print("Monkey \(i) inspected items \(monkeys[i].inspectedItems) times")
    }
}

func run2() {
    useSampleInput = true
    print("2:")
    
    var monkeys = parseMonkeys()
    
    let maxDividor = monkeys.map { $0.test.value }.reduce(1, *)
    
    for round in 1...10000 {
        monkeys.indices.forEach { i in
            var monkey = monkeys[i]
            while !monkey.isTurnFinished {
                let readonlyMonkey = monkey
                let (targetMonkey, item) = monkey.performTurnStep { worry in
                    return worry % maxDividor
                }
                monkeys[targetMonkey].take(item: item)
            }
            monkeys[i] = monkey
        }
        //print("Round \(round)")
        if round == 1 || round == 20 || round == 1000 || round == 2000 {
            printInspectedItems(round: round, monkeys: monkeys)
        }
    }
    
    let inspectedItems = monkeys.map { $0.inspectedItems }
    let sorted = inspectedItems.sorted(by: >)
    let first = sorted[0]
    let second = sorted[1]
    let answer = first * second
    print("Anwser: \(answer)")
    
    print("Done")
}
