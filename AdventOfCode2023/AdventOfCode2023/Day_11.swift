//
//  Day_11.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 20/12/2023.
//

import Foundation

public func day11_part1(_ data: String) -> Int {
    let expanded = expandUniverse(data)
    let galaxies = extractGalaxies(expanded)
    return galaxies.pairs.reduce(0) { sum, pair in
        sum + pair.0.shortestPath(to: pair.1)
    }
}

public func day11_part2(_ data: String, expandFactor: Int) -> Int {
    let expanded = expandUniverseV2(data)
    let galaxies = extractGalaxiesV2(expanded, expandFactor: expandFactor)
    return galaxies.pairs.reduce(0) { sum, pair in
        sum + pair.0.shortestPath(to: pair.1)
    }
}

extension Array where Element == Galaxy {
    var pairs: [(Galaxy, Galaxy)] {
        let allPairs = flatMap { galaxy in
            filter { $0 != galaxy }.map { [galaxy, $0].sorted(by: { $0.id
                < $1.id}) }
        }.removingDuplicates()
        return allPairs.map { ($0[0], $0[1]) }
    }
}

struct Galaxy: Equatable, Hashable {
    let id: Int
    let x: Int
    let y: Int
    
    func shortestPath(to galaxy: Galaxy) -> Int {
        let xDiff = abs(x - galaxy.x)
        let yDiff = abs(y - galaxy.y)
        return xDiff + yDiff
    }
}

func extractGalaxies(_ data: String) -> [Galaxy] {
    let lines = data.components(separatedBy: .newlines)
    let chars: [[Character]] = lines.map { line in
        line.map { $0 }
    }
    var galaxies = [Galaxy]()
    for y in 0..<chars.count {
        for x in 0..<chars[0].count {
            if chars[y][x] == "#" {
                galaxies.append(.init(id: galaxies.count + 1, x: x, y: y))
            }
        }
    }
    return galaxies
}

func extractGalaxiesV2(_ data: [[Int]], expandFactor: Int) -> [Galaxy] {
    var galaxies = [Galaxy]()
    for y in 0..<data.count {
        for x in 0..<data[0].count {
            if data[y][x] == 1 {
                // f = x - count + (expandFactor * count)
                let xExpandCount = x == 0 ? 0 : data[y][0..<x].filter { $0 == 2 }.count
                let xIncrease = expandFactor * xExpandCount - xExpandCount
                let yExpandCount = y == 0 ? 0 : data[0..<y].map { $0[x] }.filter { $0 == 2 }.count
                let yIncrease = expandFactor * yExpandCount - yExpandCount
                galaxies.append(.init(id: galaxies.count + 1, x: x + xIncrease, y: y + yIncrease))
            }
        }
    }
    return galaxies
}

// 0 = default
// 1 = galaxy
// 2 = empty row or column (expand)
func expandUniverseV2(_ data: String) -> [[Int]] {
    let lines = data.components(separatedBy: .newlines)
    let xMax = lines[0].count
    let yMax = lines.count
    var intUniverse = Array(repeating: Array(repeating: 0, count: xMax), count: yMax)
    
    var rowContainsGalaxy = [Int: Bool]()
    (0..<yMax).forEach { index in
        rowContainsGalaxy[index] = false
    }
    
    var columnContainsGalaxy = [Int: Bool]()
    (0..<xMax).forEach { index in
        columnContainsGalaxy[index] = false
    }
    for y in 0..<yMax {
        for x in 0..<xMax {
            let char = lines[y].map { $0 }[x]
            if char == "#" {
                intUniverse[y][x] = 1
                rowContainsGalaxy[y] = true
                columnContainsGalaxy[x] = true
            }
        }
    }

    var expanded = intUniverse
    for y in 0..<yMax {
        for x in 0..<xMax {
            if !rowContainsGalaxy[y]! || !columnContainsGalaxy[x]!{
                expanded[y][x] = 2 // Represents should expand
            }
        }
    }
    return expanded
}

func expandUniverse(_ data: String) -> String {
    var lines = data.components(separatedBy: .newlines)
    
    var expandedRows = [String]()
    lines.forEach { line in
        if !line.contains("#") {
            expandedRows.append(line)
            expandedRows.append(line)
        } else {
            expandedRows.append(line)
        }
    }
    lines = expandedRows
    
    var columnContainsGalaxy = [Int: Bool]()
    (0..<lines[0].count).forEach { index in
        columnContainsGalaxy[index] = false
    }
    lines.forEach { line in
        for (index, char) in line.enumerated() {
            if char == "#" {
                columnContainsGalaxy[index] = true
            }
        }
    }
    
    var expandedColumns = [String]()
    lines.forEach { line in
        var expandedLine = ""
        for (index, char) in line.enumerated() {
            expandedLine.append(char)
            if !columnContainsGalaxy[index]! {
                expandedLine.append(".")
            }
        }
        expandedColumns.append(expandedLine)
    }
    return expandedColumns.joined(separator: "\n")
}
