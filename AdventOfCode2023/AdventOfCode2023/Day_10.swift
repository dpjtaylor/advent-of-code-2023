//
//  Day_10.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 16/12/2023.
//

import Foundation

// TODO: Optimise - this takes a few mins to run for the puzzle input
public func day10_part1(_ data: String) -> Int {
    let tiles = extractPipeTiles(data)
    return tiles.biggestLoop()
}

public func day10_part1v2(_ data: String) -> Int {
    let tiles = extractPipeTiles2(data)
    return tiles.loopSteps() / 2
}

enum Direction: Equatable, CaseIterable {
    case up
    case down
    case left
    case right
}

enum TileType: Character, CaseIterable {
    case vertical = "|"
    case horizontal = "-"
    case lbend = "L"
    case jbend = "J"
    case sevenbend = "7"
    case fbend = "F"
    
    var exits: [Direction] {
        switch self {
        case .vertical:
            [.up, .down]
        case .horizontal:
            [.left, .right]
        case .lbend:
            [.up, .right]
        case .jbend:
            [.up, .left]
        case .sevenbend:
            [.left, .down]
        case .fbend:
            [.right, .down]
        }
    }
    
    var entrances: [Direction] {
        switch self {
        case .vertical:
            [.up, .down]
        case .horizontal:
            [.left, .right]
        case .lbend:
            [.down, .left]
        case .jbend:
            [.down, .right]
        case .sevenbend:
            [.right, .up]
        case .fbend:
            [.left, .up]
        }
    }
}

struct GridPoint: Equatable {
    let x: Int
    let y: Int
    
    func neighbours(xMax: Int, yMax: Int) -> [GridPoint] {
        neighbours.filter { point in
            point.x >= 0 &&
            point.x <= xMax &&
            point.y >= 0 &&
            point.y <= yMax
        }
    }
    
    var neighbours: [GridPoint] {
        [
            translate(direction: .up),
            translate(direction: .down),
            translate(direction: .left),
            translate(direction: .right)
        ]
    }
    
    func translate(direction: Direction) -> GridPoint {
        switch direction {
        case .up:
            return GridPoint(x: x, y: y - 1)
        case .down:
            return GridPoint(x: x, y: y + 1)
        case .left:
            return GridPoint(x: x - 1, y: y)
        case .right:
            return GridPoint(x: x + 1, y: y)
        }
    }
}

struct Tile {
    let type: TileType
    let position: GridPoint // TODO: Rename point
    let isStartTile: Bool
    
    init(type: TileType, position: GridPoint, isStartTile: Bool = false) {
        self.type = type
        self.position = position
        self.isStartTile = isStartTile
    }
    
    var exitPoints: [GridPoint] {
        type.exits.map { position.translate(direction: $0) }
    }
}

extension Array where Element == Tile {
    func loopSteps() -> Int {
        let startTile = first(where: \.isStartTile)!
        
        var completedLoop = false
        var currentTile = startTile
        var previousTile = startTile
        var stepCount = 0
        while !completedLoop {
            let neighbours = filter { currentTile.position.neighbours.contains($0.position) }
            let nextTiles = neighbours.filter { currentTile.exitPoints.contains($0.position) }
            assert(nextTiles.count == 2)
            let nextTilesExcludingCurrent = nextTiles.filter { $0.position != previousTile.position }
            if currentTile.isStartTile {
                assert(nextTilesExcludingCurrent.count == 2)
            } else {
                assert(nextTilesExcludingCurrent.count == 1)
            }
            previousTile = currentTile
            currentTile = nextTilesExcludingCurrent.first! // For start tile this picks arbitrarily. The rest should only have one option
            stepCount += 1
            if currentTile.isStartTile {
                completedLoop = true
            }
        }
        return stepCount
    }
}

func extractPipeTiles2(_ data: String) -> [Tile] {
    let matrix = data.components(separatedBy: .newlines)
        .map(Array.init)
    
    printMatrix(matrix)
    let yMax = matrix.count - 1
    let xMax = matrix[0].count - 1
    
    var tiles = [Tile]()
    for (y, row) in matrix.enumerated() {
        for (x, char) in row.enumerated() {
            if char == "." { continue } // Skip ground tiles
            if char == "S" {
                let startPoint = GridPoint(x: x, y: y)
                let neighbourTiles = startPoint
                    .neighbours(xMax: xMax, yMax: yMax)
                    .map { (matrix[$0.y][$0.x], $0) }
                    .filter { $0.0 != "." }
                    .map { Tile.init(type: .init(rawValue: $0.0)!, position: $0.1) }
                
                let startExits = neighbourTiles
                    .filter { $0.exitPoints.contains(startPoint) }
                    .map { tile in
                        if tile.position.x > startPoint.x {
                            return Direction.right
                        } else if tile.position.x < startPoint.x {
                            return Direction.left
                        } else if tile.position.y > startPoint.y {
                            return Direction.down
                        } else if tile.position.y < startPoint.y {
                            return Direction.up
                        }
                        fatalError("invalid neighbour tile")
                    }
                assert(startExits.count == 2)
                let startType = TileType.allCases.first { Set($0.exits) == Set(startExits) }!
                tiles.append(.init(type: startType, position: startPoint, isStartTile: true))
            } else {
                tiles.append(.init(type: TileType(rawValue: char)!, position: GridPoint(x: x, y: y)))
            }
        }
    }
    return tiles
}
// 0 0 0 0 0
// 0 S - 7 0
// 0 | 0 | 0

//public func day10_part1v2(_ data: String) -> Int {
//    let tiles = extractPipeTiles(data)
//    return -1
//}
// For each node link to neighbours
//final class PipeNode {
//    let value: PipeTile
//    let next: PipeNode
//    
//    init(value: PipeTile, next: PipeNode) {
//        self.value = value
//        self.next = next
//    }
//}

func extractPipeTiles(_ data: String) -> [PipeTile] {
    let matrix = data.components(separatedBy: .newlines)
        .map(Array.init)
    
    printMatrix(matrix)
    
    var pipeTiles = [PipeTile]()
    for (y, row) in matrix.enumerated() {
        for (x, char) in row.enumerated() {
            if char == "." { continue } // Skip ground tiles
            if char == "S" {
//                let xMin = x > 0 ? x - 1 : 0
                let xMax = x < row.count - 1 ? x + 1 : row.count - 1
//                let yMin = y > 0 ? y - 1 : 0
                let yMax = y < matrix.count - 1 ? y + 1 : matrix.count - 1
                var neighbours = [PipeTile]()
                let startPosition = GridPosition(x: x, y: y)
                let stepOptions = startPosition.neighbours(xMax: xMax, yMax: yMax)
                // Should be 2 step options we can pursue
                var exitDirections = [CompassDirection]()
                for step in stepOptions {
                    let char = matrix[step.y][step.x]
                    if char == "." { continue }
                    let type = PipeTileType(rawValue: char)!
                    let tile = PipeTile(isStartTile: false, x: step.x, y: step.y, type: type)
                    if let exitDirection = startPosition.direction(to: tile) {
                        exitDirections.append(exitDirection)
                        print("Type: \(type), x: \(step.x), y: \(step.y), canMoveTo: \(exitDirection)")
                    }
                }
                let startTileType = PipeTileType.allCases.filter { type in
                    let directions = type.directions
                    return directions.contains(exitDirections[0]) && directions.contains(exitDirections[1])
                }.first!
                print("")
//                // TODO: Only need to do north south east west here
//                for neighbourY in yMin...yMax {
//                    for neighbourX in xMin...xMax {
//                        let neighbourChar = matrix[neighbourY][neighbourX]
//                        if neighbourChar == "." || neighbourChar == "S" { continue }
//                        // print("Neighbour: \(neighbourChar), x: \(neighbourX), y: \(neighbourY)")
//                        neighbours.append(PipeTile(isStartTile: false, x: neighbourX, y: neighbourY, type: .init(rawValue: neighbourChar)!))
//                    }
//                }
                // For neighbours filter to the ones that direct to S
                pipeTiles.append(.init(isStartTile: true, x: x, y: y, type: startTileType))
            } else {
                pipeTiles.append(.init(isStartTile: false, x: x, y: y, type: PipeTileType(rawValue: char)!))
            }
        }
    }
    return pipeTiles
}

extension Array where Element == PipeTile {
    func biggestLoop() -> Int {
        let startTile = first(where: \.isStartTile)!
        let nextTiles = startTile.next(allTiles: self, ignorePosition: startTile.position)
//        let pathOne = nextTiles[0]
//        let pathTwo = nextTiles[1]
        
        var completedLoop = false
//        var loopOne = [startTile]
        var steps1 = 0
        var previousTile = startTile
        var currentTile = startTile
        while !completedLoop {
//            let next = loopOne.last!.next(allTiles: self, ignorePosition: previousTile.position).first!
            let next = currentTile.next(allTiles: self, ignorePosition: previousTile.position).first!
            previousTile = currentTile
            currentTile = next
            steps1 += 1
//            loopOne.append(next)
            if next.isStartTile {
                completedLoop = true
            }
            print("next: \(next.x), \(next.y), \(next.type.rawValue)")
//            print("Steps: \(loopOne.count)")
        }
        print("🎃🎃🎃 Completed loop 1") // TODO: Only need to take one loop

        completedLoop = false
        var steps2 = 0
        previousTile = startTile
        currentTile = startTile
//        var loopTwo = [startTile]
        while !completedLoop {
//            let next = loopTwo.last!.next(allTiles: self, ignorePosition: previousTile.position).last!
            let next = currentTile.next(allTiles: self, ignorePosition: previousTile.position).last!
            previousTile = currentTile //loopTwo.last!
            currentTile = next
            steps2 += 1
//            loopTwo.append(next)
            if next.isStartTile {
                completedLoop = true
            }
            print("next: \(next.x), \(next.y), \(next.type.rawValue)")
        }
        print("🎃🎃🎃 Completed loop 2")
        let loopOneFurthest = steps1 / 2 //(loopOne.count - 1) / 2
        let loopTwoFurthest = steps2 / 2 // (loopTwo.count - 1) / 2
        let furthest = Swift.max(loopOneFurthest, loopTwoFurthest)
        print("")
        return furthest
    }
}

private func printMatrix(_ matrix: [[Character]]) {
    for row in matrix {
        for char in row {
            print(char, terminator: " ")
        }
        print(" ")
    }
}


enum CompassDirection: CaseIterable {
    case north
    case south
    case east
    case west
    
    var xTranslation: Int {
        switch self {
        case .north, .south:
            return 0
        case .east:
            return 1
        case .west:
            return -1
        }
    }
    
    var yTranslation: Int {
        switch self {
        case .north:
            return -1
        case .south:
            return 1
        case .east, .west:
            return 0
        }
    }
}

enum PipeTileType: Character, CaseIterable {
    case vertical = "|"
    case horizontal = "-"
    case northAndEastBend = "L"
    case northAndWestBend = "J"
    case southAndWestBend = "7"
    case southAndEastBend = "F"
    
    var directions: [CompassDirection] {
        switch self {
        case .vertical:
            return [.north, .south]
        case .horizontal:
            return [.east, .west]
        case .northAndEastBend:
            return [.north, .east]
        case .northAndWestBend:
            return [.north, .west]
        case .southAndWestBend:
            return [.south, .west]
        case .southAndEastBend:
            return [.south, .east]
        }
    }

    func canEnter(in direction: CompassDirection) -> Bool {
        validEntryDirections.contains(direction)
    }

    var validEntryDirections: [CompassDirection] {
        switch self {
        case .vertical:
            return [.north, .south]
        case .horizontal:
            return [.east, .west]
        case .northAndEastBend, .northAndWestBend, .southAndWestBend, .southAndEastBend:
            return CompassDirection.allCases.filter { !directions.contains($0) }
//            [.south, .west]
//        case .northAndWestBend:
//            return [.south, .east]
//        case .southAndWestBend:
//            return [.north, .east]
//        case .southAndEastBend:
//            return [.north, .west]
        }
    }
}

struct GridPosition: Equatable {
    let x: Int
    let y: Int
    
//    isOneStep(from: position)
//    relativeDirection(from: )
    
    // Nil means we can't go there
    func direction(to tile: PipeTile) -> CompassDirection? {
        if tile.x == x && tile.y == y - 1 {
            // Going North
            return tile.type.canEnter(in: .north) ? .north : nil
        } else if tile.x == x && tile.y == y + 1 {
            // Going South
            return tile.type.canEnter(in: .south) ? .south : nil
        } else if tile.x == x + 1 && tile.y == y {
            // Going East
            return tile.type.canEnter(in: .east) ? .east : nil
        } else if tile.x == x - 1 && tile.y == y {
            // Going West
            return tile.type.canEnter(in: .west) ? .west : nil
        }
        return nil
    }
    
    func isOneStepEast(of position: GridPosition) -> Bool {
        position.x == x + 1
    }
    
//    func direction(from: GridPosition) -> CompassDirection {
//        
//    }
    
    func neighbours(xMax: Int, yMax: Int) -> [GridPosition] {
        neighbours.filter {
            $0.x >= 0 &&
            $0.x <= xMax &&
            $0.y >= 0 &&
            $0.y <= yMax
        }
    }
    
    var neighbours: [GridPosition] {
        [stepNorth, stepSouth, stepEast, stepWest]
    }
    
    var stepNorth: GridPosition {
        GridPosition(x: x, y: y - 1)
    }
    
    var stepSouth: GridPosition {
        GridPosition(x: x, y: y + 1)
    }
    
    var stepEast: GridPosition {
        GridPosition(x: x + 1, y: y)
    }
    
    var stepWest: GridPosition {
        GridPosition(x: x - 1, y: y)
    }
}

struct PipeTile {
    let isStartTile: Bool
    let position: GridPosition
    let type: PipeTileType
    
    init(isStartTile: Bool, x: Int, y: Int, type: PipeTileType) {
        self.isStartTile = isStartTile
        self.position = GridPosition(x: x, y: y)
        self.type = type
    }
    
    var x: Int {
        position.x
    }
    
    var y: Int {
        position.y
    }
    
    func next(allTiles: [PipeTile], ignorePosition: GridPosition) -> [PipeTile] {
        allTiles
            .filter { paths.contains($0.position) }
            .filter { $0.position != ignorePosition }
    }
    
    var paths: [GridPosition] {
        let exits = type.directions
        return exits.map { direction in
            switch direction {
            case .north:
                return position.stepNorth
            case .south:
                return position.stepSouth
            case .east:
                return position.stepEast
            case .west:
                return position.stepWest
            }
        }//.filter { $0 != position  } // ignore entry path
    }
}
