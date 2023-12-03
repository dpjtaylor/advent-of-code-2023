//
//  Day_01_2022.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 02/12/2023.
//

import Foundation

public func mostCalories(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    
    var maxCalories = 0
    var currentCalories = 0
    for line in lines {
        if line.isEmpty {
            if currentCalories > maxCalories {
                maxCalories = currentCalories
            }
            currentCalories = 0
            continue
        } else if let calories = Int(line) {
            currentCalories += calories
        }
    }
    return maxCalories
}

public func mostCaloriesTop3(_ data: String) -> Int {
    let lines = data.components(separatedBy: .newlines)
    
    var currentCalories = 0
    var summedCalories = [Int]()
    for line in lines {
        if line.isEmpty {
            summedCalories.append(currentCalories)
            currentCalories = 0
            continue
        } else if let calories = Int(line) {
            currentCalories += calories
        }
    }
    summedCalories.append(currentCalories)
    
    let sorted = summedCalories.sorted(by: { $0 > $1 })
    return sorted[0] + sorted[1] + sorted[2]
}
