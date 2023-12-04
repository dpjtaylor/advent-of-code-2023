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

// Refactoring of part I attempt to simplify after doing part II
public func sumEnginePartsII(_ data: String) -> Int {
    let (parts, symbols) = extractComponents(data)
    
    let nonDots = symbols.filter { $0.value != "." }
    return parts.filter { part in
        nonDots.filter { $0.isAdjacent(to: part)}.count > 0
    }
    .map(\.value)
    .reduce(0, +)
}

public func sumGearRatios(_ data: String) -> Int {
    let (parts, symbols) = extractComponents(data)
      
    return symbols.filter { $0.value == "*" } // [Symbol] - only '*'
        .map { symbol in // Transform to [[Part]] of adjacent symbols
            parts.filter { $0.isAdjacent(to: symbol) }
        }
        .filter { $0.count == 2 } // Filter to pairs -> gearParts
        .map { gearParts in
            // Multiply values of pairs reducing into [Int]
            gearParts.map(\.value).reduce(1, *)
        }
        .reduce(0, +) // sum up values in [Int]
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

// MARK: - Earlier attempt at part I

// First attempt at part I - for posterity!
public func sumEngineParts_firstAttempt(_ data: String) -> Int {
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
    outerloop: for y in yMin...yMax {
        for x in xMin...xMax {
            let scanChar = matrix[y][x]
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
