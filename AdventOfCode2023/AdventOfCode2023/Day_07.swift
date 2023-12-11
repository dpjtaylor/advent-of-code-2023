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

public func day07_part2(_ data: String) -> Int {
    let hands = extractCamelCardHands(data, isJokerActive: true)
    return hands.sorted().enumerated().map { (index, hand) in
        return (index + 1) * hand.bid
    }.reduce(0, +)
}

struct CamelCardHand: Comparable {
    static let validCards = "AKQJAKQJT98765432"
    static let validCardsJokerActive = "AKQAKQJT98765432J"
    
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
    let isJokerActive: Bool
    
    init(hand: String, bid: Int, isJokerActive: Bool = false) {
        self.hand = hand
        self.bid = bid
        self.isJokerActive = isJokerActive
        self.cardMap = Self.extractCardMap(hand)
    }
    
    var type: HandType {
        if !isJokerActive {
            return basicType
        }
        return jokerModifiedType
    }
    
    var basicType: HandType {
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
    
    var jokerModifiedType: HandType {
        let type = basicType
        if !hand.contains("J") {
            return type
        }
        let jokerCount = hand.filter { $0 == "J" }.count
        switch jokerCount {
        case 1:
            switch type {
            case .fiveOfAKind, .fullHouse: // Not possible with 1 J
                return type
            case .fourOfAKind: // AAAAJ
                return .fiveOfAKind
            case .threeOfAKind: // AAABJ
                return .fourOfAKind
            case .twoPair: // AABBJ
                return .fullHouse
            case .onePair: // JBBCD
                return .threeOfAKind
            case .highCard: // JABCD
                return .onePair
            }
        case 2:
            switch type {
            case .fiveOfAKind, .fourOfAKind, .threeOfAKind, .highCard: // Not possible with 2 Js
                return type
            case .fullHouse: // AAAJJ
                return .fiveOfAKind
            case .twoPair: // AAJJB
                return .fourOfAKind
            case .onePair: // JJABC
                return .threeOfAKind
            }
        case 3:
            switch type {
            case .fullHouse: // JJJXX
                return .fiveOfAKind
            case .threeOfAKind: // JJJXY
                return .fourOfAKind
            default:
                return type
            }
        case 4: //JJJJY
            return .fiveOfAKind
        default:
            return type
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
                    outcome = Self.points(for: lhsCard, isJokerActive: lhs.isJokerActive) < Self.points(for: rhsCard, isJokerActive: rhs.isJokerActive)
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
    
    static func points(for card: Character, isJokerActive: Bool = false) -> Int {
        if isJokerActive {
            return Self.validCardsJokerActive.reversed().firstIndex(of: card)!
        }
        return Self.validCards.reversed().firstIndex(of: card)!
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

func extractCamelCardHands(_ data: String, isJokerActive: Bool = false) -> [CamelCardHand] {
    let lines = data.components(separatedBy: .newlines)
    return lines.map { line in
        let parts = line.components(separatedBy: .whitespaces)
        return CamelCardHand(hand: parts[0], bid: Int(parts[1])!, isJokerActive: isJokerActive)
    }
}
