import Foundation

func run2() {
    useSampleInput = false
    print("2:")
    
    let instructions = input.split(separator: "\n").map { Instruction.from(input: String($0)) }
    
    var cpu = CPU(instructions: instructions)
    
    cpu.onCycleStart = { cycle, registerX in
        let column = (cycle - 1) % 40
        if column == 0 {
            print("\n", terminator: "")
        }
        
        let shouldDrawPixel = column == (registerX - 1) || column == registerX || column == (registerX + 1)
        print(shouldDrawPixel ? "#" : ".", terminator: "")
    }
    
    while !cpu.isDoneRunningProgram {
        let _ = cpu.step()
    }
    
    print("\n")
    print("Done")
}
