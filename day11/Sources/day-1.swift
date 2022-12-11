import Foundation
import Collections
import BigInt

enum Operand {
    case old
    case value(BigUInt)
}

struct Operation {
    typealias Operator = (BigUInt, BigUInt) -> BigUInt
    
    let leftOperand: Operand
    let rightOperand: Operand
    let operation: Operator
    
    init(_ left: Operand, _ operation: @escaping Operator, _ right: Operand) {
        self.leftOperand = left
        self.rightOperand = right
        self.operation = operation
    }
    
    func perform(old: BigUInt) -> BigUInt {
        let left = unwrapOperand(leftOperand, old: old)
        let right = unwrapOperand(rightOperand, old: old)
        return operation(left, right)
    }
    
    private func unwrapOperand(_ operand: Operand, old: BigUInt) -> BigUInt {
        switch operand {
            case .old:
                return old
            case .value(let value):
                return value
        }
    }
}

struct Test {
    let value: BigUInt
    
    func test(against: BigUInt) -> Bool {
        return against % value == 0
    }
}

typealias MonkeyID = Int

struct Monkey {
    typealias Item = BigUInt
    
    var items: Deque<Item>
    var operation: Operation
    var test: Test
    var targetMonkeyIfTrue: MonkeyID
    var targetMonkeyIfFalse: MonkeyID
    
    var inspectedItems = 0
    
    var isTurnFinished: Bool {
        return items.isEmpty
    }
    
    // Performs the turn and returns what item to throw to whom
    mutating func performTurnStep(worryMitigation: (BigUInt) -> BigUInt) -> (MonkeyID, Item) {
        if items.isEmpty {
            fatalError("Monkey cannot perform turn step with no item")
        }
        let item = items.removeFirst()
        inspectedItems += 1
        
        var worry: BigUInt = item
        worry = operation.perform(old: worry)
        
        worry = worryMitigation(worry)
        
        let monkeyToThrowTo: MonkeyID
        if test.test(against: worry) {
            monkeyToThrowTo = targetMonkeyIfTrue
        } else {
            monkeyToThrowTo = targetMonkeyIfFalse
        }
        
        return (monkeyToThrowTo, worry)
    }
    
    mutating func take(item: Item) {
        items.append(item)
    }
}

//MARK: Parsers

extension Test {
    static func from(_ input: Substring) -> Test {
        let split = input.split(separator: "by ")
        return Test(value: BigUInt(split[1])!)
    }
}

extension Operand {
    static func from(_ input: Substring) -> Operand {
        if input == "old" {
            return .old
        }
        return .value(BigUInt(input)!)
    }
}

extension Operation {
    static func operatorFrom(_ input: Substring) -> Operator {
        switch input {
            case "*":
                return (*)
            case "+":
                return (+)
            case "-":
                return (-)
            default:
                fatalError("Unknown operator \(input)")
        }
    }
}

func parseTest(_ rawTest: [Substring]) -> (Test, MonkeyID, MonkeyID) {
    let test = Test.from(rawTest[0])
    let trueTarget = MonkeyID(rawTest[1].split(separator: " ").last!)!
    let falseTarget = MonkeyID(rawTest[2].split(separator: " ").last!)!
    
    return (test, trueTarget, falseTarget)
}

func parseOperation(_ rawOperation: Substring) -> Operation {
    var split = rawOperation.split(separator: " ")
    
    let rightOperand = Operand.from(split.removeLast())
    let parsedOperator = Operation.operatorFrom(split.removeLast())
    let leftOperand = Operand.from(split.removeLast())
    
    return Operation(leftOperand, parsedOperator, rightOperand)
}

func parseMonkey(_ rawMonkey: Substring) -> Monkey {
    let split = rawMonkey.split(separator: "\n")
    
    let items = split[1].split(separator: ": ")[1]
        .split(separator: ", ")
        .map { Monkey.Item($0)! }
    
    let operation = parseOperation(split[2])
    let (test, trueTarget, falseTarget) = parseTest(Array(split[3...5]))
    
    return Monkey(items: Deque(items),
                  operation: operation,
                  test: test,
                  targetMonkeyIfTrue: trueTarget,
                  targetMonkeyIfFalse: falseTarget)
}

func parseMonkeys() -> [Monkey] {
    // Assume that the monkeys in the input are ordered
    let split = input.split(separator: "\n\n")
    return split.map { parseMonkey($0) }
}

func run1() {
    useSampleInput = true
    print("1:")
    
    var monkeys = parseMonkeys()
    
    for round in 1...20 {
        print("Round n°\(round)")
        monkeys.indices.forEach { i in
            var monkey = monkeys[i]
            while !monkey.isTurnFinished {
                let (targetMonkey, item) = monkey.performTurnStep { worry in
                    // Monkey gets bored
                    // No need to floor: int division returns a floored int
                    return worry / 3
                }
                monkeys[targetMonkey].take(item: item)
            }
            monkeys[i] = monkey
        }
    }
    
    let inspectedItems = monkeys.map { $0.inspectedItems }
    
    inspectedItems.indices.forEach { i in
        print("Monkey \(i) inspected items \(monkeys[i].inspectedItems) times")
    }
    
    let sorted = inspectedItems.sorted(by: >)
    let first = sorted[0]
    let second = sorted[1]
    let answer = first * second
    print("Anwser: \(answer)")
    
    print("Done")
}
