import Foundation

func run2() {
    useSampleInput = false
    print("2:")
    
    let newInput = input + "[[2]]\n[[6]]\n"
    
    let pairs = newInput.split(separator: "\n").map { (rawPacket: Substring) in
        var mutableRawPacket = rawPacket
        let parsed = parsePacketList(consumingInput: &mutableRawPacket)
        return NestedPacketData(packets: parsed)
    }
    
    let sorted = pairs.sorted { lhs, rhs in
        return lhs.isOrdered(comparedTo: rhs) == .orderedAscending
    }
    
    let stringPackets = sorted.map { $0.description }
    let firstDividerIndex = Int(stringPackets.firstIndex(of: "[[2]]")!) + 1
    let secondDividerIndex = Int(stringPackets.firstIndex(of: "[[6]]")!) + 1
    
    let answer = firstDividerIndex * secondDividerIndex
    
    print("Anwser: \(answer)")
    
    print("Done")
}
