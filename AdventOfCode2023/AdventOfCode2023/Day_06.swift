//
//  Day_06.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 10/12/2023.
//

import Foundation

public func day06_part1(_ data: String) -> Int {
    let races = extractRaceData_part1(data)
    let waysToWin = races.map(\.winningDistances.count)
    return waysToWin.reduce(1, *)
}

public func day06_part2_bruteForce(_ data: String) -> Int {
    let races = extractRaceData_part2(data)
    return races.winningDistances.count
}

public func day06_part2_quadratic(_ data: String) -> Int {
    let races = extractRaceData_part2(data)
    return races.winningDistancesQuadraticSize
}

func extractRaceData_part2(_ data: String) -> RaceData {
    let lines = data.components(separatedBy: .newlines)
    
    func extractLine(_ row: String) -> Int {
        let str = row.components(separatedBy: .whitespaces)
            .dropFirst()
            .reduce("", +)
        return Int.init(str)!
    }
    let time = extractLine(lines[0])
    let distance = extractLine(lines[1])
    return RaceData(time: time, distanceRecord: distance)
}

func extractRaceData_part1(_ data: String) -> [RaceData] {
    let lines = data.components(separatedBy: .newlines)
    let times = lines[0].components(separatedBy: .whitespaces).dropFirst().compactMap(Int.init)
    let distances = lines[1].components(separatedBy: .whitespaces).dropFirst().compactMap(Int.init)
    let races = zip(times, distances).map { RaceData(time: $0, distanceRecord: $1) }
    return races
}

struct RaceData {
    let time: Int
    let distanceRecord: Int
    
    var chargingRange: Range<Int> {
        1..<time
    }
    
    var chargingTimes: [Int] {
        Array(chargingRange)
    }
    
    var distances: [Int] {
        chargingTimes.map { chargingTime in
            let speed = chargingTime
            let timeRemaining = time - speed
            return speed * timeRemaining
        }
    }
    
    var winningDistances: [Int] {
        distances.filter { $0 > distanceRecord }
    }
        
    // distance = speed * TimeRemaining
    //          = chargingTime * (chargingTime - totalTime)
    //
    // solve for f(x) > distanceRecord
    // distanceRecord < chargingTime * (chargingTime - totalTime)
    // 0 < chargingTime * (chargingTime - totalTime) - distanceRecord
    // 0 < (chargingTime * chargingTime) - (chargingTime * totalTime) - distanceRecord
    //
    // #openness -> reviewed other solutions to find this - been a few years since I've solved quadratics!
    var winningDistancesQuadraticSize: Int {
        let lowerBound = (Double(time) - sqrt(Double(time * time - 4 * distanceRecord))) / 2
        let upperBound = (Double(time) + sqrt(Double(time * time - 4 * distanceRecord))) / 2
        return Int(upperBound) - Int(lowerBound)
    }
}
