//
//  Day_03.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 03/12/2023.
//

import Foundation

struct Part {
    let value: Int
    let startX: Int
    let endX: Int
    let y: Int
    
    func isAdjacent(to symbol: Symbol) -> Bool {
        symbol.y <= y + 1 &&
        symbol.y >= y - 1 &&
        symbol.x >= startX - 1 &&
        symbol.x <= endX + 1
    }
}

struct Symbol {
    let value: Character
    let x: Int
    let y: Int
    
    func isAdjacent(to part: Part) -> Bool {
        y <= part.y + 1 &&
        y >= part.y - 1 &&
        x >= part.startX - 1 &&
        x <= part.endX + 1
    }
}

extension Array where Element == Symbol {
    func isAdjacent(to part: Part, char: Character) -> Bool {
        var isAdjacent = false
        for symbol in filter({ $0.value != char }) {
            isAdjacent = symbol.isAdjacent(to: part)
            if isAdjacent {
                break
            }
        }
        return isAdjacent
    }
}

public func sumEnginePartsII(_ data: String) -> Int {
    let (parts, symbols) = extractComponents(data)
    
    // Find adjacent symbols for parts
    let includedParts = parts.filter { part in
        symbols.isAdjacent(to: part, char: ".")
    }
    return includedParts
        .map(\.value)
        .reduce(0, +)
}

public func sumGearRatios(_ data: String) -> Int {
    let (parts, symbols) = extractComponents(data)
  
    // Alternative works but - compiler struggles with type checking
//    let sum2 = symbols.filter({ $0.value == "*" })
//        .map({ symbol in
//            parts.filter( { $0.isAdjacent(to: symbol) })
//        })
//        .filter( { $0.count == 2 })
//        .reduce(0) { sum, gearParts in
//            sum + gearParts.map(\.value).reduce(1, *)
//        }
    
    let sum = symbols.filter { $0.value == "*" } // [Symbol] - only '*'
        .map { symbol in // Transform to [[Part]] of adjacent symbols
            parts.filter { $0.isAdjacent(to: symbol) }
        }
        .filter { $0.count == 2 } // Filter to pairs -> gearParts
        .map { gearParts in
            // Multiply values of pairs reducing into [Int]
            gearParts.map(\.value).reduce(1, *)
        }
        .reduce(0, +) // sum up values in [Int]
    
//    var sum = 0
//    gearSymbols.forEach { symbol in
//        var adjacentParts = [Part]()
//        parts.forEach { part in
//            if part.isAdjacent(to: symbol) {
//                adjacentParts.append(part)
//            }
//        }
//        if adjacentParts.count == 2 {
//            sum += adjacentParts
//                .map(\.value)
//                .reduce(1, *)
//        }
//    }
    return sum
}

private func extractComponents(_ data: String) -> ([Part], [Symbol]){
    // Create [[Character]] multidimensional array to use as an x, y grid
    let matrix = data.components(separatedBy: .newlines)
        .map(Array.init)
    
    printMatrix(matrix)

    // Extract numbers and symbols
    var parts = [Part]()
    var symbols = [Symbol]()
    for (y, row) in matrix.enumerated() {
        var currentNumber = ""
        for (x, char) in row.enumerated() {
            // Grid limits
            let xGridMax = row.count - 1
            
            if char.isNumber {
                currentNumber.append(char)
            } else {
                symbols.append(Symbol(value: char, x: x, y: y))
            }
            
            // Store number if we have found all the digits
            let xOffset = char.isNumber ? 0 : 1 // if a symbol we've gone past the end of the number
            if (!char.isNumber && currentNumber != "") || (char.isNumber && x == xGridMax){
                let startX = (x - xOffset) - (currentNumber.count - 1)
                parts.append(Part(value: Int(currentNumber)!, startX: startX, endX: x - xOffset, y: y))
                currentNumber = ""
            }
        }
    }
    return (parts, symbols)
}

public func sumEngineParts(_ data: String) -> Int {
    // Create [[Character]] multidimensional array to use as an x, y grid
    let matrix = data.components(separatedBy: .newlines)
        .map(Array.init)
    
    printMatrix(matrix)
    
    var includedNumbers = [Int]()
    for (y, row) in matrix.enumerated() {
        var currentNumber = ""
        for (x, char) in row.enumerated() {
            // Grid limits
            let xGridMax = row.count - 1
            let yGridMax = matrix.count - 1
            
            var isEndOfNumber = false
            if char.isNumber {
                currentNumber.append(char)
                if x == xGridMax {
                    isEndOfNumber = true
                }
            } else {
                isEndOfNumber = true
            }
            if currentNumber == "" {
                continue
            }
            if isEndOfNumber {
                // Check chars surrounding number
                
                // bounds of current number
                let xLowerBound = x - currentNumber.count - 1
                let xUpperBound = x
                
                // Establish range to check
                let xMin = max(0, xLowerBound)
                let xMax = min(xGridMax, xUpperBound)
                let yMin = max(0, y - 1)
                let yMax = min(yGridMax, y + 1)
                
                let shouldKeep = checkBoundaries(in: matrix, xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax)
                if shouldKeep {
                    includedNumbers.append(Int(currentNumber)!)
                }
                currentNumber = ""
            }
        }
    }
    print(includedNumbers)
    return includedNumbers.reduce(0, +)
}

// for char: Character,
// Check bounds for character matches
private func checkBoundaries(in matrix: [[Character]], xMin: Int, xMax: Int, yMin: Int, yMax: Int) -> Bool {
    // If all dots around then don't include number
    var shouldKeep = false
    outerloop: for yScan in yMin...yMax {
        for xScan in xMin...xMax {
            let scanChar = matrix[yScan][xScan]
            if !scanChar.isNumber && scanChar != "." {
                shouldKeep = true
                break outerloop
            }
        }
    }
    return shouldKeep
}

private func printMatrix(_ matrix: [[Character]]) {
    for row in matrix {
        for char in row {
//            if char == "." {
//                print(" ", terminator: " ")
//            } else {
                print(char, terminator: " ")
//            }
        }
        print(" ")
    }
}
