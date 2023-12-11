//
//  Day_08.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 11/12/2023.
//

import Foundation

public func day08_part1(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let sequence = lines[0].map(Character.init)
    let mapNodeLookup = extractMapNodes(data)
    return countSteps(from: mapNodeLookup["AAA"]!, matching: { $0 == "ZZZ" }, sequence: sequence, mapNodeLookup: mapNodeLookup)
}

func countSteps(from startingNode: MapNode, matching: (String) -> Bool, sequence: [Character], mapNodeLookup: [String: MapNode]) -> Int {
    var currentNode = startingNode
    var sequenceIndex = 0
    var steps = 0
    while !matching(currentNode.name) {
        let pathSelected = currentNode.path(for: sequence[sequenceIndex])
//        print("Node: \(currentNode.name) = (\(currentNode.leftPath), \(currentNode.rightPath)) => \(sequence[sequenceIndex]) => \(path)")
        currentNode = mapNodeLookup[pathSelected]!
        sequenceIndex = (sequenceIndex + 1) % sequence.count
        steps += 1
    }
    return steps
}

// The patterns for reaching a path ending in Z repeat
// - find the steps to get to Z from each starting node
// - find the lowest common multiple of those step counts to find the minimum number of steps for all the paths to converge
//
// #transparency: needed a hint on this one to understand the Least Common Multiple approach
public func day08_part2(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let sequence = lines[0].map(Character.init)
    let mapNodeLookup = extractMapNodes(data)
    let startingNodes = mapNodeLookup.keys.filter { $0.last! == "A" }.map { mapNodeLookup[$0]! }
    return startingNodes.map { mapNode in
        let steps = countSteps(from: mapNode, matching: { $0.last! == "Z"}, sequence: sequence, mapNodeLookup: mapNodeLookup)
        print(steps)
        return steps
    }.reduce(1) { partialResult, steps in
        leastCommonMultiple(partialResult, steps)
    }
}

// The largest positive integer that divides each of the integers
// https://en.wikipedia.org/wiki/Greatest_common_divisor
func greatestCommonDiviser(_ a: Int, _ b: Int) -> Int {
    let output = b == 0 ? a : greatestCommonDiviser(b, a % b)
    return output
}

// The smallest positive integer that is divisible by both a and b.
// https://en.wikipedia.org/wiki/Least_common_multiple
//
// e.g. in the example there are two paths - one takes 2 steps, one takes 3
// => the lowest common multiple is 2 * 3 = 6 with a greatest common divisor of 1
func leastCommonMultiple(_ a: Int, _ b: Int) -> Int {
    if a == 0 || b == 0 { return 0 }
    return a * b / greatestCommonDiviser(a, b)
}

func extractMapNodes(_ data: String) -> [String: MapNode] {
    let lines = data.components(separatedBy: .newlines).suffix(from: 2)
    var mapNodeLookup = [String: MapNode]() // Dictionary much faster than using array and repeated filtering
    lines.forEach { line in
        let parts = line.split(separator: " = ")
        let secondPart = parts.last!
            .split(separator: ", ")
            .map { $0.replacingOccurrences(of: "(", with: "") }
            .map { $0.replacingOccurrences(of: ")", with: "") }
        let name = String(parts.first!)
        mapNodeLookup[name] = MapNode(name: name, leftPath: secondPart.first!, rightPath: secondPart.last!)
    }
    return mapNodeLookup
}

struct MapNode {
    let name: String
    let leftPath: String
    let rightPath: String
    
    func path(for choice: Character) -> String {
        if choice == "L" {
            return leftPath
        }
        return rightPath
    }
}
