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
    var currentNode = mapNodeLookup["AAA"]!
    var sequenceIndex = 0
    var steps = 0
    while currentNode.name != "ZZZ" {
        let pathSelected = currentNode.path(for: sequence[sequenceIndex])
//        print("Node: \(currentNode.name) = (\(currentNode.leftPath), \(currentNode.rightPath)) => \(sequence[sequenceIndex]) => \(path)")
        currentNode = mapNodeLookup[pathSelected]!
        sequenceIndex = (sequenceIndex + 1) % sequence.count
        steps += 1
    }
    return steps
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
