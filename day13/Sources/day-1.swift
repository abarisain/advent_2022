import Foundation

typealias Packet = Int

protocol PacketData: CustomStringConvertible {
    func isOrdered(comparedTo rhs: PacketData) -> ComparisonResult
}

class SimplePacketData: PacketData {
    let packet: Packet
    
    init(packet: Packet) {
        self.packet = packet
    }
    
    func isOrdered(comparedTo rhs: PacketData) -> ComparisonResult {
        // This breaks 10 programming best practices
        if let rhs = rhs as? NestedPacketData {
            return NestedPacketData(packets: [self]).isOrdered(comparedToNested: rhs)
        }
        // This breaks 10 more
        let rhPacket = (rhs as! SimplePacketData).packet
        if packet < rhPacket {
            return .orderedAscending
        }
        if packet == rhPacket {
            return .orderedSame
        }
        return .orderedDescending
    }
    
    var description: String {
        return "\(packet)"
    }
}

class NestedPacketData: PacketData {
    let packets: [PacketData]
    
    init(packets: [PacketData]) {
        self.packets = packets
    }
    
    func isOrdered(comparedTo rhs: PacketData) -> ComparisonResult {
        var nestedPacket = rhs as? NestedPacketData
        if nestedPacket == nil {
            nestedPacket = NestedPacketData(packets: [(rhs as! SimplePacketData)])
        }
        
        return isOrdered(comparedToNested: nestedPacket!)
    }
    
    func isOrdered(comparedToNested rhs: NestedPacketData) -> ComparisonResult {
        let rightPackets = rhs.packets
        
        // Continue as long as numbers are equal, succeed on first < and fail on first >
        // If lhs' size is < than rhs', just stop and consider the packets ordered
        for i in packets.indices {
            if i >= rightPackets.count {
                // We're out of right packets => out of order
                return .orderedDescending
            }
            let comparaison = packets[i].isOrdered(comparedTo: rightPackets[i])
            if comparaison == .orderedAscending {
                return .orderedAscending
            }
            if comparaison == .orderedDescending {
                return .orderedDescending
            }
        }
        return .orderedAscending
    }
    
    var description: String {
        let map = packets.map { $0.description }.joined(separator: ",")
        return "[\(map)]"
    }
}

// Parses the packet list by CONSUMING the input data (to allow recursion)
func parsePacketList(consumingInput input: inout Substring) -> [PacketData] {
    var out = [PacketData]()
    
    let firstChar = input.popFirst()
    guard firstChar == "[" else {
        fatalError("Expected list start, got something else \(String(describing: firstChar))")
    }
    
    var numberAcc = ""
    
    while !input.isEmpty {
        // Peek next char, if it's an array start it will be consumed by the
        // recursive call
        if input.first == "[" {
            let nestedList = NestedPacketData(packets: parsePacketList(consumingInput: &input))
            out.append(nestedList)
            continue
        }
        
        let char = input.popFirst()!
        
        if char == "]" || char == "," {
            // Closing a list acts like ,] so that we don't miss
            // the last item
            // We need to check if acc had something so we handle sublists properly
            if !numberAcc.isEmpty {
                let packet = Packet(numberAcc)!
                numberAcc = ""
                out.append(SimplePacketData(packet: packet))
            }
            if char == "]" {
                return out
            }
        }
        
        if char == "0" || char == "1" || char == "2" || char == "3" || char == "4" || char == "5"
            || char == "6" || char == "7" || char == "8" || char == "9" {
            numberAcc += "\(char)"
        }
        
        
    }
    
    
    fatalError("Missing list end")
}

func run1() {
    useSampleInput = false
    print("1:")
    
    let pairs = input.split(separator: "\n\n").map {
        $0.split(separator: "\n")
            .map { (rawPacket: Substring) in
                var mutableRawPacket = rawPacket
                let parsed = parsePacketList(consumingInput: &mutableRawPacket)
                return NestedPacketData(packets: parsed)
            }
    }
    
    //pairs.forEach { print("\($0[0])\n\($0[1])\n") }
    
    let comparedPairs = pairs.map { $0[0].isOrdered(comparedTo: $0[1]) == .orderedAscending }
    
    var answer = 0
    for i in comparedPairs.indices {
        if comparedPairs[i] {
            print("Pair \(i+1) is ordered")
            print("Left: \(pairs[i][0])")
            print("Right: \(pairs[i][1])")
            print("")
            answer += i + 1
        }
    }
    
    print("Answer: \(answer)")
    
    print("Done")
}
