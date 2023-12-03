//
//  Day_02_2022.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 02/12/2023.
//

import Foundation

struct RockPaperScissorsRound {
    enum Outcome: String {
        case lose = "X"
        case draw = "Y"
        case win = "Z"
        
        var score: Int {
            switch self {
            case .lose:
                return 0
            case .draw:
                return 3
            case .win:
                return 6
            }
        }
    }
    
    enum Shape: String {
        case rock = "A"
        case paper = "B"
        case scissors = "C"
        
        var beats: Shape {
            switch self {
            case .rock:
                return .scissors
            case .paper:
                return .rock
            case .scissors:
                return .paper
            }
        }
        
        var losesTo: Shape {
            switch self {
            case .rock:
                return .paper
            case .paper:
                return .scissors
            case .scissors:
                return .rock
            }
        }
        
        var score: Int {
            switch self {
            case .rock:
                return 1
            case .paper:
                return 2
            case .scissors:
                return 3
            }
        }
    }
    
    var outcome: Outcome {
        .init(rawValue: data.components(separatedBy: " ").last!)!
    }
    
    var opponent: Shape {
        .init(rawValue: data.components(separatedBy: " ").first!)!
    }
    
    var response: Shape {
        switch outcome {
        case .lose:
            return opponent.beats
        case .draw:
            return opponent
        case .win:
            return opponent.losesTo
        }
    }

    // rock beats scissor - A Z = loss, C X = win
    // paper beats rock - B X = loss, A Y = win
    // scissor beats paper - C Y = loss, B Z = win
    // Draw if same - A X, B Y, C Z
    let roundPoints = [
        "A C": 0 + 3,
        "C A": 6 + 1,
        "B A": 0 + 1,
        "A B": 6 + 2,
        "C B": 0 + 2,
        "B C": 6 + 3,
        "A A": 3 + 1,
        "B B": 3 + 2,
        "C C": 3 + 3,
    ]
    
    // Opponent: A (rock), B (paper), C (scissors)
    // Response: X (rock), Y (paper), Z (scissors)
    let data: String
    
    var score: Int {
        outcome.score + response.score
    }
}

public func rockPaperScissorsScore(_ data: String) -> Int {
    data.components(separatedBy: .newlines)
        .map(RockPaperScissorsRound.init(data:))
        .map(\.score)
        .reduce(0, +)
}
