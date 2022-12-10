import Foundation
import Collections

enum Instruction {
    case noop
    case addx(value: Int)
    
    static func from(input: String) -> Instruction {
        if input == "noop" {
            return .noop
        } else if input.starts(with: "addx") {
            let split = input.split(separator: " ")
            return .addx(value: Int(split[1])!)
        }
        fatalError("Unknown instruction \(input)")
    }
}

struct CPU {
    var instructions: [Instruction]
    var registerX: Int
    var cycle: UInt
    
    typealias ExecutionStack = Deque<Instruction>
    
    private var executionStack: ExecutionStack
    
    var isDoneRunningProgram: Bool {
        return executionStack.isEmpty
    }
    
    var onCycleStart: ((UInt, Int) -> Void)? = nil
    
    init(instructions: [Instruction]) {
        self.instructions = instructions
        registerX = 1
        cycle = 1
        executionStack = CPU.unroll(instructions: instructions)
    }
    
    mutating func reset() {
        self = .init(instructions: self.instructions)
    }
    
    // Returns true if a step was executed, false if not (happens when we're out of instructions)
    mutating func step() -> Bool {
        guard let instruction = executionStack.popFirst() else {
            return false
        }
        
        if let onCycleStart {
            onCycleStart(cycle, registerX)
        }
        
        switch instruction {
            case .noop:
                break
            case let .addx(value):
                //print("Add \(value), cycle: \(cycle)")
                registerX += value
        }
        
        cycle += 1
        
        return true
    }
    
    // Returns true if ran to the end, false if stopped prematurely
    mutating func stepUntil(cycle targetCycle: UInt) -> Bool {
        assert(cycle < targetCycle)
        while cycle < targetCycle {
            if !step() {
                return false
            }
        }
        return true
    }
    
    // Returns true if ran to the end, false if stopped prematurely
    mutating func stepFor(cycles howMany: UInt) -> Bool {
        return stepUntil(cycle: cycle + howMany)
    }
    
    // Unrolls multi-cycle instructions by padding them with no-ops
    private static func unroll(instructions: [Instruction]) -> ExecutionStack {
        var out: ExecutionStack = Deque(minimumCapacity: instructions.count * 2)
        
        for instruction in instructions {
            // Padding
            switch instruction {
                case .addx:
                    out.append(.noop)
                default:
                    break
            }
            out.append(instruction)
        }
        
        return out
    }
}

func run1() {
    useSampleInput = false
    print("1:")
    
    let instructions = input.split(separator: "\n").map { Instruction.from(input: String($0)) }
    
    var cpu = CPU(instructions: instructions)
    
    var acc = 0
    for i in stride(from: 20, to: UInt.max, by: 40) {
        let isDone = cpu.stepUntil(cycle: i)
        if !isDone {
            print("Done in \(cpu.cycle) cycles")
            break
        }
        let signalStrength = cpu.registerX * Int(i)
        print("Strength: \(signalStrength), Cycle: \(cpu.cycle), X: \(cpu.registerX)")
        acc += signalStrength
    }
    
    let answer = acc
    
    if useSampleInput {
        assert(answer == 13140)
    } else {
        assert(answer == 17020)
    }
    
    print("Answer: \(answer)")
    
    print("Done")
}
