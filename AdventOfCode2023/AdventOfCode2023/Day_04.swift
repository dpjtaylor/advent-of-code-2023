//
//  Day_04.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 04/12/2023.
//

import Foundation

// Find sum of winning numbers
public func day04_part1(_ data: String) -> Int {
    extractCards(data)
        .map(\.matchesCount)
        .map { count in
            Int(pow(2.0, Double(count - 1)))
        }.reduce(0, +)
}

// Start    count:  6
// Card: 1, count: 10 (4 matches) - 6 + (1 copy * 4 matches) = 10
// Card: 2, count: 14 (2 matches) - 10 + (2 copies * 2 matches) = 14
// Card: 3, count: 22 (2 matches) - 14 + (4 copies * 2 matches) = 22
// Card: 4, count: 30 (1 match)   - 22 + (8 copies * 1 matches) = 30
// Card: 5, count: 30 (0 matches) - 30 + (13 copies * 0 matches) = 30
// Card: 6, count: 30 (0 matches) - 30 + (1 copy * 0 matches) = 30

public func day04_part2_v2(_ data: String) -> Int {
    let cards = extractCards(data)

    // Start with 1 copy of each card
    var copyCount = [Int].init(repeating: 1, count: cards.count)
    var cardCount = cards.count
    for card in cards {
        // Card 1. 4 matches -> increment +4 x1  -> [1, 2, 2, 2, 2, 1]
        // Card 2. 2 matches -> increment +2 x2  -> [1, 2, 4, 4, 2, 1]
        // Card 3. 2 matches -> increment +2 x4  -> [1, 2, 4, 8, 6, 1]
        // Card 4. 1 matches -> increment +1 x8  -> [1, 2, 4, 8, 14, 1]
        // Card 5. 0 matches -> increment +0 x14 -> [1, 2, 4, 8, 14, 1]
        // Card 6. 0 matches -> increment +0 x1  -> [1, 2, 4, 8, 14, 1]
        
        // increment copy count for next matchesCount items
        for i in card.id..<card.id + card.matchesCount {
            // copies = 1, matches = 4 -> increment next 4 counts by 1
            copyCount[i] += copyCount[card.id - 1]
        }
        cardCount += copyCount[card.id - 1] * card.matchesCount
    }
    return cardCount
}

// MARK: - Discarded

// Incredibly slow with puzzle input - might take days to run
public func day04_part2_v1(_ data: String) -> Int {
    let allCards = extractCards(data)
    var cardsWon = allCards
   
    for cardId in 1...allCards.count {
        // Process all the 1s, then all the 2s etc...
        let matches = cardsWon.filter { $0.id == cardId }
//        print(">>> Card \(cardId), matches: \(matches.count)")
        matches.forEach { _ in
            let matchesCount = allCards[cardId - 1].matchesCount
            if matchesCount > 0 {
                let nextCardIndex = cardId
                let newCards = Array(allCards[nextCardIndex...(nextCardIndex + matchesCount - 1)])
                cardsWon.append(contentsOf: newCards)
                cardsWon = cardsWon.sorted { $0.id < $1.id }
//                print("Card: \(cardId), won: \(newCards.map(\.id))")
            } else {
//                print("Card: \(cardId), won: 0")
            }
        }
        print("Card: \(cardId), count: \(cardsWon.count)")
    }
    return cardsWon.count
}

struct Card {
    let id: Int
    let winningNumbers: [Int]
    let ourNumbers: [Int]
    
    var matchesCount: Int {
        winningNumbers.filter(ourNumbers.contains(_:)).count
    }
    
    init(id: Int, winningData: String, ourData: String) {
        self.id = id
        winningNumbers = winningData
            .components(separatedBy: .whitespaces)
            .compactMap(Int.init)
        ourNumbers = ourData
            .components(separatedBy: .whitespaces)
            .compactMap(Int.init)
    }
}

private func extractCards(_ data: String) -> [Card] {
    data.replacingOccurrences(of: "  ", with: " ")
        .components(separatedBy: .newlines)
        .map { $0.split(separator: ": ").last! }
        .map { $0.split(separator: " | ").map(String.init) } // -> [winning, ours]
        .enumerated()
        .map { Card(id: $0 + 1, winningData: $1[0], ourData: $1[1]) }
}
