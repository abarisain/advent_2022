fileprivate enum FightResult {
    case win
    case loss
    case draw
    
    func score() -> Int {
        switch(self) {
            case .win:
                return 6
            case .draw:
                return 3
            case .loss:
                return 0
        }
    }
}

fileprivate enum HandShape {
    case rock
    case paper
    case scissors
    
    func score() -> Int {
        switch(self) {
            case .rock:
                return 1
            case .paper:
                return 2
            case .scissors:
                return 3
        }
    }
    
    func fight(against: HandShape) -> FightResult {
        if self == against {
            return .draw
        }
        switch(self) {
            case .rock:
                if against == .scissors {
                    return .win
                }
                return .loss
            case .paper:
                if against == .rock {
                    return .win
                }
                return .loss
            case .scissors:
                if against == .paper {
                    return .win
                }
                return .loss
        }
    }
    
    static func from(_ raw: String) -> HandShape {
        if raw == "A" || raw == "X" {
            return .rock
        }
        
        if raw == "B" || raw == "Y" {
            return .paper
        }
        
        if raw == "C" || raw == "Z" {
            return .scissors
        }
        
        fatalError("unknown shape: \(raw)")
    }
}

fileprivate struct Round {
    let opponent: HandShape
    let our: HandShape
    
    func score() -> Int {
        return our.fight(against: opponent).score() + our.score()
    }
}

func run1() {
    let rawRounds = input.split(separator: "\n")
    
    let rounds = rawRounds.map { rawRound in
        let rawMoves = rawRound.split(separator: " ").map{ s in String(s) }
        return Round(opponent: HandShape.from(rawMoves[0]), our: HandShape.from(rawMoves[1]))
    }
    
    let scores = rounds.map { $0.score() }
    
    let score = scores.reduce(0, +)
    
    print("Score: \(score)")
    
    print("Done")
}
