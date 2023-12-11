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
    let mapNodes = extractMapNodes(data)
    var currentNode = mapNodes.filter { $0.name == "AAA" }.first!
    var sequenceIndex = 0
    var steps = 0
    while currentNode.name != "ZZZ" {
        let path = currentNode.path(for: sequence[sequenceIndex])
//        print("Node: \(currentNode.name) = (\(currentNode.leftPath), \(currentNode.rightPath)) => \(sequence[sequenceIndex]) => \(path)")
        currentNode = mapNodes.filter { $0.name == currentNode.path(for: sequence[sequenceIndex]) }.first!
        sequenceIndex = (sequenceIndex + 1) % sequence.count
        steps += 1
    }
    return steps
}

func extractMapNodes(_ data: String) -> [MapNode] {
    let lines = data.components(separatedBy: .newlines).suffix(from: 2)
    return lines.map { line in
        let parts = line.split(separator: " = ")
        let secondPart = parts.last!
            .split(separator: ", ")
            .map { $0.replacingOccurrences(of: "(", with: "") }
            .map { $0.replacingOccurrences(of: ")", with: "") }
        return MapNode(name: String(parts.first!), leftPath: secondPart.first!, rightPath: secondPart.last!)
    }
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
