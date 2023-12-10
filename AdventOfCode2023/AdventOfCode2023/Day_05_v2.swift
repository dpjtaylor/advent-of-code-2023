//
//  Day_05_v2.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 09/12/2023.
//

import Foundation

public func day05_part1_v2(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seeds = extractSeeds(lines[0])
    let almanac = extractAlmanac(data)
    
    let locations = almanac.process(seeds)
    return locations.min() ?? -1
}

public func day05_part2_v2(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seedRanges = extractSeedRanges(lines[0])
    let almanac = extractAlmanac(data)
    
    let locations = almanac.process(seedRanges)
    print(locations.map(\.lowerBound).sorted(by: { $0 < $1 }))
    return locations.map(\.lowerBound).min() ?? -1
}


public func day05_part2_v2_bruteForce(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seedRanges = extractSeedRanges(lines[0])
    let almanac = extractAlmanac(data)
//    let seedsList = seedRanges.map(Array.init)
    var minLocation = Int.max
    for seedRange in seedRanges {
        print("👻👻👻")
        print("Seeds:   \(seedRange)")
        for seed in seedRange {
            let location = almanac.process(seed)
            minLocation = min(minLocation, location)
        }
        print("Min Location:    \(minLocation)")
    }
//    for seeds in seedsList {
//        print("👻👻👻")
//        print("Seeds:           \(seeds)")
//        let locations = almanac.process(seeds)
//        print("Locations:       \(locations)")
//        let location = locations.min()!
//        print("Min Location:    \(location)")
//        minLocation = min(minLocation, location)
//    }
//    let locations = almanac.process(seeds)
//    print("👻👻👻")
//    print(locations.squashRanges())
//    print(locations.map(\.lowerBound).sorted(by: { $0 < $1 }))
//    return locations.map(\.lowerBound).min() ?? -1
    return minLocation
}

func extractAlmanac(_ data: String) -> Almanac {
    let numberArrays = data.split(separator: " map:")
        .dropFirst() // drop text before first occurance of " map:"
        .map { $0.components(separatedBy: .newlines) } // ["", "50 98 2", "52 50 48", "", "soil-to-fertilizer"]
        .compactMap {
            $0.map { $0.components(separatedBy: .whitespaces) }
                .map { $0.compactMap(Int.init) }
        }
    let stages = numberArrays
        .map { $0.filter { $0.count == 3} } // [[50, 98, 2], [52, 50, 48]]
        .map { SeedProcessingStage(data: $0) }
            
    return Almanac(stages: stages)
}

struct Almanac {
    let stages: [SeedProcessingStage]
    
    var seedToSoil: SeedProcessingStage {
        stages[0]
    }
    
    var soilToFertilizer: SeedProcessingStage {
        stages[1]
    }
    
    var fertilizerToWater: SeedProcessingStage {
        stages[2]
    }
    
    var waterToLight: SeedProcessingStage {
        stages[3]
    }
    
    var lightToTemperature: SeedProcessingStage {
        stages[4]
    }
    
    var temperatureToHumidity: SeedProcessingStage {
        stages[5]
    }
    
    var humidityToLocation: SeedProcessingStage {
        stages[6]
    }
    
    func process(_ seed: Int) -> Int {
        let soil = seedToSoil.process(seed)
        let fertilizer = soilToFertilizer.process(soil)
        let water = fertilizerToWater.process(fertilizer)
        let light = waterToLight.process(water)
        let temperature = lightToTemperature.process(light)
        let humidity = temperatureToHumidity.process(temperature)
        let location = humidityToLocation.process(humidity)
        return location
    }
    
    func process(_ seeds: [Int]) -> [Int] {
        var locations = [Int]()
        for seed in seeds {
            let soil = seedToSoil.process(seed)
            let fertilizer = soilToFertilizer.process(soil)
            let water = fertilizerToWater.process(fertilizer)
            let light = waterToLight.process(water)
            let temperature = lightToTemperature.process(light)
            let humidity = temperatureToHumidity.process(temperature)
            let location = humidityToLocation.process(humidity)
//            print("Seed \(seed), soil \(soil), fertilizer \(fertilizer), water \(water), light \(light), temperature \(temperature), humidity \(humidity), location \(location)")
            locations.append(location)
        }
        return locations
    }
    
    // Seed 79..<93
    // -> soil [Range(81..<95)]
    // -> fertilizer [Range(81..<95)]
    // -> water [Range(81..<95)]
    // -> light [Range(74..<88), Range(95..<95)]
    // -> temperature [Range(74..<77), Range(45..<56), Range(95..<95)]
    // -> humidity [Range(74..<77), Range(46..<57), Range(95..<95)]
    // -> location [Range(78..<81), Range(46..<56), Range(60..<61), Range(95..<95)]
    
    // Seed 82, soil 84, fertilizer 84, water 84, light 77, temperature 45, humidity 46, location 46
    
    func process(_ seeds: [Range<Int>]) -> [Range<Int>] {
        var locations = [Range<Int>]()
        for seed in seeds {
            let soil = seedToSoil.process([seed])
            let fertilizer = soilToFertilizer.process(soil)
            let water = fertilizerToWater.process(fertilizer)
            let light = waterToLight.process(water)
            let temperature = lightToTemperature.process(light)
            let humidity = temperatureToHumidity.process(temperature)
            let location = humidityToLocation.process(humidity)
            print("Seed \(seed)")
            print("-> soil \(soil)")
            print("-> fertilizer \(fertilizer)")
            print("-> water \(water)")
            print("-> light \(light)")
            print("-> temperature \(temperature)")
            print("-> humidity \(humidity)")
            print("-> location \(location)")
            locations += location
        }
        return locations
    }
}

extension Array where Element == Range<Int> {
    func sortedByLowerBound() -> [Range<Int>] {
        sorted { $0.lowerBound < $1.lowerBound }
    }
    
    func sortRanges() -> [Range<Int>] {
        sorted(by: { $0.lowerBound < $1.lowerBound} )
    }
    
    func squashRanges2() -> [Range<Int>] {
        var ranges = sortedByLowerBound()
        var squashed = [Range<Int>]()
        while ranges.count > 0 {
            if ranges.count == 1 {
                // Last item - take
                squashed.append(ranges[0])
                ranges.remove(at: 0)
            } else if ranges[0].upperBound >= ranges[1].lowerBound {
                // 7,8,9     10,11,12 -> 7,8,9,10,11,12 (ranges[0].upperBound == 10 == ranges[1].upperBound)
                // 7,8       10,11,12 -> no overlap (ranges[0].upperBound == 9 < ranges[1].upperBound)
                // Overlapping - expand first to include second then remove second
                ranges[0] = ranges[0].lowerBound..<ranges[1].upperBound
                ranges.remove(at: 1)
            } else {
                // No overlap -> take first
                squashed.append(ranges[0])
                ranges.remove(at: 0)
            }
        }
        return squashed
    }
    
    func squashRanges() -> [Range<Int>] {
        var ranges = self.sortRanges()
        var squashed = [Range<Int>]()
        while ranges.count > 0 {
            let range = ranges[0]
            if ranges.count > 1 {
                if range.overlaps(ranges[1]) {
                    if (range.contains(ranges[1].lowerBound) && range.contains(ranges[1].upperBound)) || (ranges[1].contains(range.lowerBound) && ranges[1].contains(range.upperBound)) {
                        let lower = Swift.min(range.lowerBound, ranges[1].lowerBound)
                        let upper = Swift.max(range.upperBound, ranges[1].upperBound)
                        ranges[0] = lower..<upper
                        ranges.remove(at: 1)
                    } else if range.contains(ranges[1].lowerBound) && !range.contains(ranges[1].upperBound) {
                        ranges[0] = range.lowerBound..<ranges[1].upperBound
                        ranges.remove(at: 1)
                    } else if range.contains(ranges[1].upperBound) && !range.contains(ranges[1].lowerBound) {
                        ranges[0] = range.lowerBound..<ranges[1].upperBound
                        ranges.remove(at: 1)
                    }
                } else {
                    squashed.append(range)
                    ranges.remove(at: 0)
                }
            } else if ranges.count == 1 {
                squashed.append(range)
                ranges.remove(at: 0)
            }
        }
        return squashed
    }
}

struct SeedProcessingStage {
    let maps: [SourceToDestination]
    
    init(data: [[Int]]) {
        // [[50, 98, 2], [52, 50, 48]]
        self.maps = data.map {
            SourceToDestination.init(destinationStart: $0[0], sourceStart: $0[1], rangeLength: $0[2])
        }
    }

    func process(_ source: Int) -> Int {
        maps.compactMap { $0.process(source) }.first ?? source
    }
    
//    func process(_ source: Range<Int>) -> [Range<Int>] {
//        maps.flatMap { $0.process(source) ?? [] } //?? [source] }
//    }
    
    func process(_ sources: [Range<Int>]) -> [Range<Int>] {
        var input = sources
        var output = [Range<Int>]()
        while input.count > 0 {
            var mapped = false
            for map in maps {
                let outcome = map.process(input[0])
                if let mappedRange = outcome.mappedRange {
                    output.append(mappedRange)
                    mapped = true
                    input.remove(at: 0)
                    input += outcome.unmappedRanges // feed back in unprocessed ranges to be processed
                    break
                }
            }
            if !mapped {
                output.append(input[0])
                input.remove(at: 0)
            }
        }
        
//        var output = [Range<Int>]()
//        sources.forEach { source in
//            var mapped = false
//            maploop: for map in maps {
//                let outcome = map.process(source)
//                if let mappedRange = outcome.mappedRange {
//                    mapped = true
//                    break maploop
//                }
////                if let currentOutput = map.process(source) {
////                    output += currentOutput
////                    mapped = true
////                    break maploop
////                }
//            }
//            if !mapped {
//                output.append(source)
//            }
//        }
        return output.squashRanges2()
//        sources.flatMap(process(_:))
    }
    
//    func process(_ sources: [Range<Int>]) -> [Range<Int>] {
//        maps.flatMap { $0.process(sources) }
//            .squashRanges2()
//        sources.flatMap { source in
//            maps.compactMap { 
//                $0.process(source)} ?? [source]
//        }
//        .squashRanges()
//    }
}

struct SourceToDestination {
    let sourceRange: Range<Int> // TODO: Rename
    let offset: Int
    
    struct MappingOutcome {
        let mappedRange: Range<Int>?
        let unmappedRanges: [Range<Int>]
        
        init(mappedRange: Range<Int>? = nil, unmappedRanges: [Range<Int>] = []) {
            self.mappedRange = mappedRange
            self.unmappedRanges = unmappedRanges
        }
    }
    
    init(destinationStart: Int, sourceStart: Int, rangeLength: Int) {
        self.sourceRange = sourceStart ..< sourceStart + rangeLength
        self.offset = destinationStart - sourceStart
    }
    
    func process(_ source: Int) -> Int? {
        if sourceRange.contains(source) {
            return source + offset
        }
        return nil
    }
    
//    func process(_ sources: [Range<Int>]) -> [Range<Int>] {
//        sources.flatMap { range in
//            process(range) ?? []
//        }
////        .sorted { $0.lowerBound < $1.lowerBound }
////        .sorted { $0.lowerBound < $1.lowerBound }
//        //.sortRanges()
////        sources.flatMap { source in
////            process(source) ?? [source]
////        }
//        //        sources.flatMap { source in
//        //            maps.compactMap {
//        //                $0.process(source)} ?? [source]
//        //        }
////        .squashRanges()
//    }
    
    
    // Need to track which sources are mapped and which are not
    // Unmapped sources after processing should be passed through to next stage
    func process(_ sources: Range<Int>) -> MappingOutcome {
        print("input range:  \(sources)")
        print("map range  :  \(sourceRange)")
        if !sourceRange.overlaps(sources) {
            print("Not mapped")
            return MappingOutcome()
        }
        
        var unmapped = [Range<Int>]()
        if sources.lowerBound < sourceRange.lowerBound {
            unmapped.append(sources.lowerBound..<sourceRange.lowerBound)
        }
        let intersection = sources.intersection(with: sourceRange)!
        print("intersection: \(intersection)")
        let mapped = intersection.offset(by: offset)
        if sources.upperBound > sourceRange.upperBound {
            unmapped.append(sourceRange.upperBound..<sources.upperBound)
        }
        print("offset:       \(offset)")
        print("unmapped range: \(unmapped)")
        return MappingOutcome(mappedRange: mapped, unmappedRanges: unmapped)
        
//        // Fully contained
//        if sourceRange.contains(sources.lowerBound) && sourceRange.contains(sources.upperBound) {
//            print("output range: \([sources.lowerBound + offset ..< sources.upperBound + offset])")
//            return [sources.lowerBound + offset ..< sources.upperBound + offset]
//        }
//        // Lower bounds overlap but not upper
//        if sourceRange.contains(sources.lowerBound) && !sourceRange.contains(sources.upperBound) {
//            let mappedRange = sources.lowerBound + offset ..< sourceRange.upperBound + offset
//            let identityRange = sourceRange.upperBound ..< sources.upperBound
//            print("output range: \([mappedRange, identityRange])")
//            return [mappedRange, identityRange]
//        }
//        // Upper bounds overlap but not lower
//        if !sourceRange.contains(sources.lowerBound) && sourceRange.contains(sources.upperBound) {
//            let identityRange = sources.lowerBound ..< sourceRange.lowerBound
//            let mappedRange = sourceRange.lowerBound + offset ..< sources.upperBound + offset
//            print("output range: \([identityRange, mappedRange])")
//            return [identityRange, mappedRange]
//        }
//        // SourceRange is in the middle but upper and lower bounds are outside
//        let lowerIdentityRange = sources.lowerBound ..< sourceRange.lowerBound
//        let upperIdentityRange = sourceRange.upperBound ..< sources.upperBound
//        let mappedRange = sourceRange.lowerBound + offset ..< sourceRange.upperBound + offset
//        print("output range: \([lowerIdentityRange, mappedRange, upperIdentityRange])")
//        return [lowerIdentityRange, mappedRange, upperIdentityRange]
    }
}

extension Range<Int> {
    func intersection(with range: Range<Int>) -> Range<Int>? {
        if !overlaps(range) { return nil }
        let lowerBound = Swift.max(lowerBound, range.lowerBound)
        let upperBound = Swift.min(upperBound, range.upperBound)
        return lowerBound..<upperBound
    }
    
    func offset(by value: Int) -> Range<Int> {
        (lowerBound + value)..<(upperBound + value)
    }
    
    //        if (range.contains(ranges[1].lowerBound) && range.contains(ranges[1].upperBound)) || (ranges[1].contains(range.lowerBound) && ranges[1].contains(range.upperBound)) {
    //            let lower = Swift.min(range.lowerBound, ranges[1].lowerBound)
    //            let upper = Swift.max(range.upperBound, ranges[1].upperBound)
    //            ranges[0] = lower..<upper
    //            ranges.remove(at: 1)
    //        } else if range.contains(ranges[1].lowerBound) && !range.contains(ranges[1].upperBound) {
    //            ranges[0] = range.lowerBound..<ranges[1].upperBound
    //            ranges.remove(at: 1)
    //        } else if range.contains(ranges[1].upperBound) && !range.contains(ranges[1].lowerBound) {
    //            ranges[0] = range.lowerBound..<ranges[1].upperBound
    //            ranges.remove(at: 1)
    //        }
    
//    func overlapRange() -> Range<Int>? {
//        return nil
//    }
    
    
//    func process(_ sources: Range<Int>) -> [Range<Int>] {
//        print("input range: \(sources)")
//        print("map range  : \(sourceRange)")
//        if !sourceRange.overlaps(sources) {
//            print("output range: \([sources])")
//            return [sources]
//        }
//        // Fully contained
//        if sourceRange.contains(sources.lowerBound) && sourceRange.contains(sources.upperBound) {
//            print("output range: \([sources.lowerBound + offset ..< sources.upperBound + offset])")
//            return [sources.lowerBound + offset ..< sources.upperBound + offset]
//        }
//        // Lower bounds overlap but not upper
//        if sourceRange.contains(sources.lowerBound) && !sourceRange.contains(sources.upperBound) {
//            let mappedRange = sources.lowerBound + offset ..< sourceRange.upperBound + offset
//            let identityRange = sourceRange.upperBound ..< sources.upperBound
//            print("output range: \([mappedRange, identityRange])")
//            return [mappedRange, identityRange]
//        }
//        // Upper bounds overlap but not lower
//        if !sourceRange.contains(sources.lowerBound) && sourceRange.contains(sources.upperBound) {
//            let identityRange = sources.lowerBound ..< sourceRange.lowerBound
//            let mappedRange = sourceRange.lowerBound + offset ..< sources.upperBound + offset
//            print("output range: \([identityRange, mappedRange])")
//            return [identityRange, mappedRange]
//        }
//        // SourceRange is in the middle but upper and lower bounds are outside
//        let lowerIdentityRange = sources.lowerBound ..< sourceRange.lowerBound
//        let upperIdentityRange = sourceRange.upperBound ..< sources.upperBound
//        let mappedRange = sourceRange.lowerBound + offset ..< sourceRange.upperBound + offset
//        print("output range: \([lowerIdentityRange, mappedRange, upperIdentityRange])")
//        return [lowerIdentityRange, mappedRange, upperIdentityRange]
//    }
}
