//
//  Day_05.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 08/12/2023.
//

import Foundation

// Find lowest location number
public func day05_part1(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seeds = extractSeeds(lines[0])
    let seedMaps = extractSeedMaps(data)
    
    var destinations = seeds
    for batch in seedMaps {
        destinations = destinations.map {
            batch.destination($0)
        }
    }
    return destinations.min() ?? -1
}

public func day05_part2(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seedRanges = extractSeedRanges(lines[0])
    let seedMaps = extractSeedMaps(data)
    seedMaps.forEach { seedMap in
        seedMap.forEach { seedMapInner in
            print(seedMapInner.offset)
        }
    }
    
//    // For seed to soil find ranges matching
//    for seedRange in seedRanges {
//        print(seedRange)
//        // 79..<93
//        // 55..<68
//    }
//    
//    var destinations = seedRanges
//    for batch in seedMaps {
//        print(destinations)
//        print(batch.sourceRanges)
//        destinations = destinations.map {
//            batch.destination($0)
//        }
        
        // If range found we map the range
//        let rangesFound = destinationRanges.filter {
//            $0.overlaps(batch.sourceRanges)
//        }
        
        // If range not found we split the range and map identity
//    }
    
    
//    let seeds = seedRanges.flatMap { [Int].init($0) }
    var destinations = seedRanges
    for batch in seedMaps {
        destinations = batch.destinationRanges(destinations)
    }
    print(destinations)
    return destinations.first!.lowerBound
    
//    var destinations = [Int]()
//    for seedRange in seedRanges {
//        for i in seedRange {
//            var rangeDestinations: [Int] = .init(seedRange)
//            for batch in seedMaps {
//                rangeDestinations = rangeDestinations.map {
//                    batch.destination($0)
//                }
//            }
//        }
//    }
    
//    var lowerBoundDestinations = lowerBounds
//    for batch in seedMaps {
//        lowerBoundDestinations = lowerBoundDestinations.map {
//            batch.destination($0)
//        }
//    }
//    let minLowerBounds = lowerBoundDestinations.min() ?? -1
//    
//    var upperBoundDestinations = upperBounds
//    for batch in seedMaps {
//        upperBoundDestinations = upperBoundDestinations.map {
//            batch.destination($0)
//        }
//    }
//    let minUpperBounds = upperBoundDestinations.min() ?? -1
//    return min(minLowerBounds, minUpperBounds)
}

// Rename SeedMap?
struct SeedMapBatch {
    let seedMaps: [SeedMap]
    
    var batchOffset: Int {
        seedMaps.reduce(0) { partialResult, seedMap in
            partialResult + seedMap.offset
        }
    }
}

struct SeedMap: Equatable {
    let sourceStart: Int
    let destinationStart: Int // min value in range - filter for minimum input in range?
    let rangeLength: Int
    
    var sourceRange: Range<Int> {
        sourceStart ..< sourceStart + rangeLength
    }
    
    var destinationRange: Range<Int> {
        destinationStart ..< destinationStart + rangeLength
    }
    
    var sourceEnd: Int {
        sourceStart + rangeLength
    }
    
    var destinationEnd: Int {
        destinationStart + rangeLength
    }
    
    var offset: Int {
        destinationStart - sourceStart
    }
    
    func inRange(_ source: Int) -> Bool {
        sourceStart ..< sourceEnd ~= source
    }
    
    func destinationRanges(_ seedRange: Range<Int>) -> [Range<Int>] {
        if !seedRange.overlaps(sourceRange) {
            return [seedRange]
        }
        print("seeds: \(seedRange)")
        let overlapRange = seedRange.clamped(to: sourceRange)
        print("source: \(sourceRange)")
        print("overlap: \(overlapRange)")
        print("start destination range: \(destinationRange)")
        
        // Lower range is from lower sourceRange to
        let lowerRange = seedRange.lowerBound ..< overlapRange.lowerBound
        print("lowerRange: \(lowerRange)")
        let upperRange = overlapRange.upperBound ..< seedRange.upperBound
        print("upperRange: \(upperRange)")
        let destinationRange = overlapRange.lowerBound + offset ..< overlapRange.upperBound + offset
        print("destinationRange: \(destinationRange)")
        var ranges = [Range<Int>]()
        if lowerRange.count > 0 {
            ranges.append(lowerRange)
        }
        ranges.append(destinationRange)
        if upperRange.count > 0 {
            ranges.append(upperRange)
        }
        let sorted = ranges.sorted(by: { $0.lowerBound < $1.lowerBound } )
        print(sorted)
        return sorted
    }
    
    func destination(_ source: Int) -> Int {
        // if source in source range -> map to destination
        if inRange(source) { // TODO: Don't need check
            let offset = source - sourceStart
            return destinationStart + offset
        }
        return source
    }
}

extension Array where Element == SeedMap {
    var sourceStartValues: [Int] {
        map(\.sourceStart)
    }
    
    var sourceRanges: [Range<Int>] {
        map(\.sourceRange)
    }
    
    func destinationRanges(_ sourceRange: Range<Int>) -> [Range<Int>] {
        flatMap { $0.destinationRanges(sourceRange) }
            .sorted(by: { $0.lowerBound < $1.lowerBound} )
    }
    
    func destinationRanges(_ sourceRanges: [Range<Int>]) -> [Range<Int>] {
        var ranges = sourceRanges.flatMap { range in
            destinationRanges(range)
        }
        .sorted(by: { $0.lowerBound < $1.lowerBound} )
        
        var mergedRanges = [Range<Int>]()
        while ranges.count > 0 {
            let range = ranges[0]
            if ranges.count > 1 {
                if range.overlaps(ranges[1]) {
                    ranges[0] = range.lowerBound..<ranges[1].upperBound
                    ranges.remove(at: 1)
                } else {
                    mergedRanges.append(range)
                    ranges.remove(at: 0)
                }
            } else if ranges.count == 1 {
                mergedRanges.append(range)
                ranges.remove(at: 0)
            }
        }
        return mergedRanges
    }
    
    func destination(_ source: Int) -> Int {
        if let seedMap = filter( { $0.inRange(source) } ).first {
            return seedMap.destination(source)
        }
        return source
    }
}

func extractSeedMaps(_ data: String) -> [[SeedMap]] {
    let numberArrays = data.split(separator: " map:")
        .dropFirst() // drop text before first occurance of " map:" -> array of 7 strings with sample data
        .map { $0.components(separatedBy: .newlines) } // ["", "50 98 2", "52 50 48", "", "soil-to-fertilizer"]
        .compactMap {
            $0.map { $0.components(separatedBy: .whitespaces) }
                .map { $0.compactMap(Int.init) }
        } // [[], [50, 98, 2], [52, 50, 48], [], []]
    return numberArrays
        .map { $0.filter { $0.count == 3} } // [[50, 98, 2], [52, 50, 48]]
        .map { $0.map { SeedMap.init(sourceStart: $0[1], destinationStart: $0[0], rangeLength: $0[2]) } }
}

func extractSeeds(_ row: String) -> [Int] {
    let seeds = row.components(separatedBy: .whitespaces)
        .dropFirst() // drop "seeds: "
        .compactMap(Int.init)
    print(seeds)
    return seeds
}

func extractSeedRanges(_ row: String) -> [Range<Int>] {
    let seeds = extractSeeds(row)
    
    var seedRanges = [Range<Int>]()
    for i in stride(from: 0, to: seeds.count - 1, by: 2) {
        let lowerBound = seeds[i]
        let upperBound = lowerBound + seeds[i + 1]
        seedRanges.append(lowerBound ..< upperBound)
    }
    return seedRanges
}
