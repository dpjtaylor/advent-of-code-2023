//
//  Day_07.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 11/12/2023.
//

import Foundation

public func day07_part1(_ data: String) -> Int {
    let hands = extractCamelCardHands(data)
    return hands.sorted().enumerated().map { (index, hand) in
        return (index + 1) * hand.bid
    }.reduce(0, +)
}

struct CamelCardHand: Comparable {
    static let validCards = "AKQJAKQJT98765432"
    
    enum HandType: Int {
        case fiveOfAKind = 6
        case fourOfAKind = 5
        case fullHouse = 4
        case threeOfAKind = 3
        case twoPair = 2
        case onePair = 1
        case highCard = 0
    }
    
    let hand: String
    let bid: Int
    let cardMap: [Character: Int]
    
    init(hand: String, bid: Int) {
        self.hand = hand
        self.bid = bid
        self.cardMap = Self.extractCardMap(hand)
    }
    
    var type: HandType {
        let maxCount = cardMap.values.max()
        switch maxCount {
        case 5:
            return .fiveOfAKind
        case 4:
            return .fourOfAKind
        case 3:
            if numberOfPairs == 2 {
                return .fullHouse
            }
            return .threeOfAKind
        case 2:
            if numberOfPairs == 2 {
                return .twoPair
            }
            return .onePair
        default:
            return .highCard
        }
    }
    
//    If two hands have the same type, a second ordering rule takes effect. Start by comparing the first card in each hand. If these cards are different, the hand with the stronger first card is considered stronger. If the first card in each hand have the same label, however, then move on to considering the second card in each hand. If they differ, the hand with the higher second card wins; otherwise, continue with the third card in each hand, then the fourth, then the fifth.
    static func < (lhs: CamelCardHand, rhs: CamelCardHand) -> Bool {
        let lhsType = lhs.type
        let rhsType = rhs.type
        if lhsType != rhsType {
            return lhsType.rawValue < rhsType.rawValue
        }
        if lhsType == rhsType {
            // Compare first, second, third card
            var outcome: Bool = false
            for (lhsCard, rhsCard) in zip(lhs.hand, rhs.hand) {
                if lhsCard != rhsCard {
                    outcome = Self.points(for: lhsCard) < Self.points(for: rhsCard)
                    break
                }
            }
            return outcome
        }
        return false
    }
    
    /// Two or more cards
    var numberOfPairs: Int {
        cardMap.keys.reduce(0) { partialResult, card in
            if let count = cardMap[card],
               count >= 2 {
                return partialResult + 1
            }
            return partialResult
        }
    }
    
    static func points(for card: Character) -> Int {
        Self.validCards.reversed().firstIndex(of: card)!
    }
    
    static func extractCardMap(_ hand: String) -> [Character: Int] {
        var cardMap = [Character: Int]()
        for char in hand {
            if let count = cardMap[char] {
                cardMap[char] = count + 1
            } else {
                cardMap[char] = 1
            }
        }
        return cardMap
    }
}

func extractCamelCardHands(_ data: String) -> [CamelCardHand] {
    let lines = data.components(separatedBy: .newlines)
    return lines.map { line in
        let parts = line.components(separatedBy: .whitespaces)
        return CamelCardHand(hand: parts[0], bid: Int(parts[1])!)
    }
}
