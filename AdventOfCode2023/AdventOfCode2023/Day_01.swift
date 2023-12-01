//
//  Day_01.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 01/12/2023.
//

import Foundation

// MARK: - Part I

public func extractCalibrationValuev1(_ data: String) -> Int {
    let rows = data.split(whereSeparator: \.isNewline).map { String($0) }
    let rowValues = rows.map(extractCalibrationValueForRowv1)
    let summed = rowValues.reduce(0) { sum, value in
        sum + value
    }
    return summed
}

private func extractCalibrationValueForRowv1(_ row: String) -> Int {
    guard let firstNumber = (row.first { $0.isNumber }),
          let lastNumber = (row.last { $0.isNumber }) else {
        return -1
    }
    let combined = "\(firstNumber)\(lastNumber)"
    return Int(combined) ?? -1
}

// MARK: - Part II

public struct Digit {
    public let text: String
    public let value: String
    
    public static func digit(for char: Character) -> Digit? {
        allDigits.first { $0.value == String(char) }
    }
    
    public static func intValue(for char: Character) -> Int? {
        if let value = digit(for: char)?.value {
            return Int(value)
        }
        return -1
    }
}

let allDigits = [
    Digit(text: "one", value: "1"),
    Digit(text: "two", value: "2"),
    Digit(text: "three", value: "3"),
    Digit(text: "four", value: "4"),
    Digit(text: "five", value: "5"),
    Digit(text: "six", value: "6"),
    Digit(text: "seven", value: "7"),
    Digit(text: "eight", value: "8"),
    Digit(text: "nine", value: "9"),
]

let digitText = allDigits.map(\.text)

public func extractCalibrationValuev2(_ data: String) -> Int {
    let rows = data.split(whereSeparator: \.isNewline).map { String($0) }
    let rowValues = rows.map(extractCalibrationValueForRowv2)
    let summed = rowValues.reduce(0) { sum, value in
        sum + value
    }
    return summed
}

private func extractCalibrationValueForRowv2(_ row: String) -> Int {
    // Replace numbers with text equivalents
    let textOnly = replaceDigitsWithText(row)
    
    let digitsContained = allDigits.filter { digit in
        textOnly.contains(digit.text)
    }
    
    // Find first occurances of found digits
    let frontDigits = digitsContained.map { digit in
        let index = textOnly.range(of: digit.text)!.lowerBound
        return (digit, index)
    }
    
    // last occurance of found digits
    let backDigits = digitsContained.map { digit in
        let index = textOnly.range(of: digit.text, options: .backwards)!.lowerBound
        return (digit, index)
    }
    
    // Sort ascending by index
    let digitsFound = (frontDigits + backDigits).sorted { $0.1 < $1.1 }.map { $0.0 }
    
    guard let firstNumber = digitsFound.first?.value,
          let lastNumber = digitsFound.last?.value else {
        return -1
    }
    let combined = "\(firstNumber)\(lastNumber)"
    return Int(combined) ?? -1
}

private func replaceDigitsWithText(_ row: String) -> String {
    let numbers = row.filter(\.isNumber)
    var updatedRow = row
    for number in numbers {
        guard let digit = Digit.digit(for: number) else { continue }
        updatedRow = updatedRow.replacingOccurrences(of: String(number), with: digit.text)
    }
    return updatedRow
}
