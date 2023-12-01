//
//  Day01Tests.swift
//  AdventOfCode2023Tests
//
//  Created by David Taylor on 01/12/2023.
//

import AdventOfCode2023
import Foundation
import XCTest

final class Day01Tests: XCTestCase {
    func test_extractCalibrationValueFromSingleLine() {
        let data = "1abc2"
        let expected = 12
        XCTAssertEqual(expected, extractCalibrationValue(data))
    }
}
