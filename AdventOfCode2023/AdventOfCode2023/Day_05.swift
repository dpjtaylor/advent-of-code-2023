//
//  Day_05.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 09/12/2023.
//

import Foundation

public func day05_part1(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seeds = extractSeeds(lines[0])
    let almanac = extractAlmanac(data)
    let locations = almanac.process(seeds)
    return locations.min() ?? -1
}

public func day05_part2(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seedRanges = extractSeedRanges(lines[0])
    let almanac = extractAlmanac(data)
    let locations = almanac.process(seedRanges)
    return locations.map(\.lowerBound).min() ?? -1
}

public func day05_part2_bruteForce(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    let seedRanges = extractSeedRanges(lines[0])
    let almanac = extractAlmanac(data)
    var minLocation = Int.max
    for seedRange in seedRanges {
        for seed in seedRange {
            let location = almanac.process(seed)
            minLocation = min(minLocation, location)
        }
    }
    return minLocation
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
//            print("Seed \(seed)")
//            print("-> soil \(soil)")
//            print("-> fertilizer \(fertilizer)")
//            print("-> water \(water)")
//            print("-> light \(light)")
//            print("-> temperature \(temperature)")
//            print("-> humidity \(humidity)")
//            print("-> location \(location)")
            locations += location
        }
        return locations
    }
}

struct SeedProcessingStage {
    let maps: [SourceToDestination]
    
    init(data: [[Int]]) {
        self.maps = data.map {
            SourceToDestination.init(destinationStart: $0[0], sourceStart: $0[1], rangeLength: $0[2])
        }
    }

    func process(_ source: Int) -> Int {
        maps.compactMap { $0.process(source) }.first ?? source
    }
    
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
                    input += outcome.unmappedRanges // queue for processing
                    break
                }
            }
            if !mapped {
                output.append(input[0])
                input.remove(at: 0)
            }
        }
        return output.squashRanges()
    }
}

struct SourceToDestination {
    let mapRange: Range<Int>
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
        self.mapRange = sourceStart ..< sourceStart + rangeLength
        self.offset = destinationStart - sourceStart
    }
    
    func process(_ source: Int) -> Int? {
        if mapRange.contains(source) {
            return source + offset
        }
        return nil
    }
    
    func process(_ sources: Range<Int>) -> MappingOutcome {
//        print("input range:  \(sources)")
//        print("map range  :  \(mapRange)")
        if !mapRange.overlaps(sources) {
//            print("Not mapped")
            return MappingOutcome()
        }
        
        var unmapped = [Range<Int>]()
        if sources.lowerBound < mapRange.lowerBound {
            unmapped.append(sources.lowerBound..<mapRange.lowerBound)
        }
        let intersection = sources.intersection(with: mapRange)!
//        print("intersection: \(intersection)")
        let mapped = intersection.offset(by: offset)
        if sources.upperBound > mapRange.upperBound {
            unmapped.append(mapRange.upperBound..<sources.upperBound)
        }
//        print("offset:       \(offset)")
//        print("unmapped range: \(unmapped)")
        return MappingOutcome(mappedRange: mapped, unmappedRanges: unmapped)
    }
}

// MARK: - Range<Int> + intersection and offset

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
}

// MARK: - Array+Range<Int>

extension Array where Element == Range<Int> {
    /// Squash adjacent ranges together if overlapping
    func squashRanges() -> [Range<Int>] {
        var ranges = sorted { $0.lowerBound < $1.lowerBound }
        var squashed = [Range<Int>]()
        while ranges.count > 0 {
            if ranges.count == 1 {
                // Last item - take
                squashed.append(ranges[0])
                ranges.remove(at: 0)
            } else if ranges[0].upperBound >= ranges[1].lowerBound {
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
}
