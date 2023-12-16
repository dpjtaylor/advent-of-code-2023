//
//  Day_09.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 11/12/2023.
//

import Foundation

public func day09_part1(_ data: String) -> Int {
    return extractOasisSequences(data)
        .map(nextValue(for:))
        .reduce(0, +)
}

public func day09_part2(_ data: String) -> Int {
    let rows = extractOasisSequences(data)
    return rows
        .map(previousValue(for:))
        .reduce(0, +)
}

func previousValue(for sequence: [Int]) -> Int {
    return nextValue(for: sequence.reversed())
}

func nextValue(for sequence: [Int]) -> Int {
    var children = [[Int]]()
    var previous = sequence
    var foundZeroDiff = false
    while !foundZeroDiff {
        var next = [Int]()
        for i in 1..<previous.count {
            next.append(previous[i] - previous[i - 1])
        }
        let nextSet = Set(next)
        foundZeroDiff = nextSet.count == 1
        children.append(next)
        previous = next
    }
    let sumLastValues = children
        .map { $0.last! }
        .reduce(0, +)
    let nextValue = sumLastValues + sequence.last!
//    print("diff: \(sumLastValues), return: \(nextValue)")
    return nextValue
}

func extractOasisSequences(_ data: String) -> [[Int]] {
    let lines = data.components(separatedBy: .newlines)
    return lines
        .map { $0.components(separatedBy: .whitespaces)
            .compactMap(Int.init) }
}
