//
//  Day_03_2022.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 03/12/2023.
//

import Foundation

extension Character {
    //           10        20        30        40        50
    // "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    //  1234567890123456789012345678901234567890123456789012
    
    var priorityValue: Int {
        let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        if let i = alphabet.firstIndex(of: self) {
            let index: Int = alphabet.distance(from: alphabet.startIndex, to: i)
            return index + 1
        }
        fatalError("Invalid character")
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

public func prioritiseRuckSackItems(_ data: String) -> Int {
    let chars = data.components(separatedBy: .newlines)
        .map { line in
            let halfSackSize = line.count / 2
            let compartment1Chars = Array(String(line.prefix(halfSackSize)))
            let compartment2Chars = Array(String(line.suffix(halfSackSize)))
//            let overlap = compartment1Chars
//                .filter(compartment2Chars.contains(_:))
//            overlap.forEach { char in
//                print("-----------------------------------")
//                print("length: \(line.count)")
//                print("compartment 1: \(compartment1Chars)")
//                print("compartment 2: \(compartment2Chars)")
//                print("overlap: \(overlap)")
//            }
            return compartment1Chars
                .filter(compartment2Chars.contains(_:)).first! // can be mutiple entries per line
        }
    
    let values = chars
        .map(\.priorityValue)
        
    //    let unique = Array(Set(duplicates))
    for char in chars {
        print("char: \(char), value: \(char.priorityValue)")
    }
    return values.reduce(0, +)
}

public func prioritiseBadges(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    var groups = [[String]]()
    for i in 0..<(lines.count / 3) {
        let startIndex = 3 * i
        groups.append([lines[startIndex], lines[startIndex + 1], lines[startIndex + 2]])
    }
    return groups.map { bags in
        bags[0].filter(bags[1].contains(_:)).filter(bags[2].contains(_:)).first!
    }.map(\.priorityValue)
        .reduce(0, +)
//    for filter in filtered {
//        print("filter: \(filter)")
//    }
//    print("ha")
//        .map { line in
//            let halfSackSize = line.count / 2
//            let compartment1Chars = Array(String(line.prefix(halfSackSize)))
//            let compartment2Chars = Array(String(line.suffix(halfSackSize)))
//            return compartment1Chars
//                .filter(compartment2Chars.contains(_:)).first! // can be mutiple entries per line
//        }
    
//    let values = chars
//        .map(\.priorityValue)
        
    //    let unique = Array(Set(duplicates))
//    for char in chars {
//        print("char: \(char), value: \(char.priorityValue)")
//    }
//    return -1 //values.reduce(0, +)
}

// vJrwpWtwJgWrhcsFMMfFFhFp
