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

// 6 + (1 copy * 4 matches) = 10
// 10 + (2 copies * 2 matches) = 14
// 14 + (4 copies * 2 matches) = 22
// 22 + (8 copies * 1 matches) = 30
// 30 + (13 copies * 0 matches) = 30
// 30 + (1 copy * 0 matches) = 30

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
    }
    var count = cards.count
    for card in cards {
        count += copyCount[card.id - 1] * card.matchesCount
    }
    return count
}


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

// Card 1 has four matching numbers, so you win one copy each of the next four cards: cards 2, 3, 4, and 5.

// My Cards = [1, 2, 3, 4, 5, 6]
// check card 1 -> 4 matches -> [1, 2*, 3*, 4*, 5*, 2, 3, 4, 5, 6] -> 10 cards
// check card 2 -> 4 matches -> [1, 2*, 3*, 4*, 5*, 2, 3, 4, 5, 6] -> 10 cards
//
// Card 1 -> 4 matches -> win 1 of 2, 3, 4, 5
// Card 2 -> 2 matches -> win 3, 4
// Card 2 (copy) -> 2 matches -> win 3, 4
// Card 3 (1 original, 3 copies) -> 2 matches -> win 4 copies of card 4 and 5
// Card 4 (1 original, 7 copies) -> 1 match -> win 8 copies of card 5
// Card 5 (1 orginal, 13 copies) -> 0 matches
// Card 6 (1 original) -> matches
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

//Card 1 has four matching numbers, so you win one copy each of the next four cards: cards 2, 3, 4, and 5.
//Your original card 2 has two matching numbers, so you win one copy each of cards 3 and 4.
//Your copy of card 2 also wins one copy each of cards 3 and 4.
//Your four instances of card 3 (one original and three copies) have two matching numbers, so you win four copies each of cards 4 and 5.
//Your eight instances of card 4 (one original and seven copies) have one matching number, so you win eight copies of card 5.
//Your fourteen instances of card 5 (one original and thirteen copies) have no matching numbers and win no more cards.
//Your one instance of card 6 (one original) has no matching numbers and wins no more cards.
//Once all of the originals and copies have been processed, you end up with 1 instance of card 1, 2 instances of card 2, 4 instances of card 3, 8 instances of card 4, 14 instances of card 5, and 1 instance of card 6. In total, this example pile of scratchcards causes you to ultimately have 30 scratchcards!
//
//Process all of the original and copied scratchcards until no more scratchcards are won. Including the original set of scratchcards, how many total scratchcards do you end up with?
