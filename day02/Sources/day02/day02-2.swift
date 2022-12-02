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
    
    static func from(_ raw: String) -> FightResult {
        if raw == "X" {
            return .loss
        }
        
        if raw == "Y" {
            return .draw
        }
        
        if raw == "Z" {
            return .win
        }
        
        fatalError("unknown result: \(raw)")
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
    
    static func forOutcome(_ outcome: FightResult, against: HandShape) -> HandShape {
        if outcome == .draw {
            return against
        }
        if outcome == .win {
            switch against {
                case .scissors:
                    return .rock
                case .rock:
                    return .paper
                case .paper:
                    return .scissors
            }
        }
        if outcome == .loss {
            switch against {
                case .scissors:
                    return .paper
                case .rock:
                    return .scissors
                case .paper:
                    return .rock
            }
        }
        
        fatalError("unexpected outcome")
    }
    
    static func from(_ raw: String) -> HandShape {
        if raw == "A" {
            return .rock
        }
        
        if raw == "B" {
            return .paper
        }
        
        if raw == "C" {
            return .scissors
        }
        
        fatalError("unknown shape: \(raw)")
    }
}

fileprivate struct Round {
    let outcome: FightResult
    let ourShape: HandShape
    
    func score() -> Int {
        return outcome.score() + ourShape.score()
    }
}

func run2() {
    let rawRounds = input.split(separator: "\n")
    
    let rounds = rawRounds.map { rawRound in
        let rawMoves = rawRound.split(separator: " ").map{ s in String(s) }
        let opponentMove = HandShape.from(rawMoves[0])
        let outcome = FightResult.from(rawMoves[1])
        return Round(outcome: outcome, ourShape: HandShape.forOutcome(outcome, against:opponentMove))
    }
    
    let scores = rounds.map { $0.score() }
    
    let score = scores.reduce(0, +)
    
    print("Score: \(score)")
    
    print("Done")
}
