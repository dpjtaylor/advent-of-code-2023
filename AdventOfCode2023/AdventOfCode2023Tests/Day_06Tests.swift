//
//  Day_06Tests.swift
//  AdventOfCode2023Tests
//
//  Created by David Taylor on 10/12/2023.
//

import Foundation
import XCTest
@testable import AdventOfCode2023

final class Day06Tests: XCTestCase {
    
    // Starting speed == 0 mm per ms
    // Charge speed at rate of 1 mm per ms
    // Find number of ways to win for each race
    // multiply values together e.g. 4 * 8 * 9 = 288 for sample input
    func test_part1_sampleData() {
        XCTAssertEqual(288, day06_part1(sampleData))
    }
    
    func test_part1_puzzleInput() {
        XCTAssertEqual(633080, day06_part1(puzzleInput))
    }
    
    func test_part2_sampleData() {
        XCTAssertEqual(71503, day06_part2_bruteForce(sampleData))
    }
    
//    func test_part2_puzzleInput_bruteForce() {
//        XCTAssertEqual(20_048_741, day06_part2_bruteForce(puzzleInput))
//    }
    
    func test_part2_puzzleInput() {
        XCTAssertEqual(20_048_741, day06_part2_quadratic(puzzleInput))
    }
    
    // First race lasts 7 milliseconds, record distance is 9mmm
    // Second race lasts 15 milliseconds, record distance is 40mm
    // Third race lasts 30 milliseconds, record distance is 200mm
    let sampleData = """
    Time:      7  15   30
    Distance:  9  40  200
    """
    
    let puzzleInput = """
    Time:        34     90     89     86
    Distance:   204   1713   1210   1780
    """
}
