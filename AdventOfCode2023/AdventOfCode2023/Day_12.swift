//
//  Day_12.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 21/12/2023.
//

import Foundation

public func day12_part1(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    return lines.reduce(0) { sum, row in
        sum + calculatePossibleArrangements(row)
    }
}

public func day12_part2(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    return lines.reduce(0) { sum, row in
        let arrangements = calculatePossibleArrangements(row, unfold: true)
//        print("Row: \(row), arrangements: \(arrangements)")
        return sum + arrangements
    }
}

func calculatePossibleArrangements(_ row: String, unfold: Bool = false) -> Int {
    Day_12.resultCache = [:]
    let rowComponents = row
        .components(separatedBy: .whitespaces)
    var pattern = rowComponents.first!.map { $0 }
    var groups = rowComponents
        .last!
        .split(separator: ",")
        .map(String.init)
        .compactMap(Int.init)

    if unfold {
        pattern = pattern.repeated(count: 5, separator: "?")
        groups = groups.repeated(count: 5)
    }
    return arrangements(pattern, groups: groups, current: pattern)
}

extension Array {
    func repeated(count: Int) -> [Element] {
        var arr = [Element]()
        for _ in 0..<count {
            arr = arr + self
        }
        return arr
    }
}

extension Array where Element == Character {
    func repeated(count: Int, separator: Character) -> [Character] {
        var arr = [Character]()
        for i in 0..<count {
            arr = arr + self
            if i < count - 1 {
                arr.append(separator)
            }
        }
        return arr
    }
}

enum Day_12 {
    static var validArrangements = [String]()
    static var resultCache = [String: Int]()
}

func arrangements(_ remaining: [Character], groups: [Int], current: [Character]) -> Int {
    let key = String(remaining) + groups.map { String($0) }.joined()
    if let cached = Day_12.resultCache[key] {
        return cached
    }
    
    guard !groups.isEmpty else {
        if !remaining.contains("#") {
            // Debugging - print all valid arrangements
//            Day_12.validArrangements.append(String(current))
//            print(Day_12.validArrangements)
//            Day_12.validArrangements = []
        }
        return remaining.contains("#") ? 0 : 1 // If hashes remaining -> invalid
    }
    if remaining.isEmpty { return 0 } // groups left but now characters left -> invalid
    
    var count = 0
    let char = remaining[0]
    let group = groups[0]
    
    // Treat char as "." -> branch 1
    if char == "." || char == "?" {
        var current = current
        current[current.count - remaining.count] = "."
        count += arrangements(Array(remaining.dropFirst()), groups: groups, current: Array(current)) // TODO: use subsequence?
    }
    
    // Treat char as "#" -> branch 2
    if char == "#" || char == "?" {
        let uninterrupted = remaining.count >= group ? !remaining[0..<group].contains(".") : false
        let collisionFree = remaining.count > group && remaining[group] != "#" || remaining.count == group
        if uninterrupted && collisionFree {
            var current = current
            let startIndex = current.count - remaining.count
            let endIndex = startIndex + group
            current.replaceSubrange(startIndex..<endIndex, with: Array(repeating: "#", count: group))
            if endIndex < current.count {
                current[endIndex] = "."
            }
            if groups.count == 1 {
                // replace any trailing ?? as about to drop last group
                current = current.map { $0 == "?" ? "." : $0 }
            }
            count += arrangements(Array(remaining.dropFirst(group + 1)), groups: Array(groups.dropFirst()), current: Array(current))
        }
    }
    Day_12.resultCache[key] = count
    return count
}
