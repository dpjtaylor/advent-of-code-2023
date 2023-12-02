//
//  Day_02Tests.swift
//  AdventOfCode2023Tests
//
//  Created by David Taylor on 02/12/2023.
//

import Foundation
import XCTest
@testable import AdventOfCode2023

final class Day02Tests: XCTestCase {
    
    // MARK: - Part I
    
    func test_extractGames_shouldExtractGames() {
        let games = extractGames(sampleData)
        
        // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        let game1 = games[0]
        XCTAssertEqual(1, game1.id)
        XCTAssertEqual(3, game1.draws.count)
        XCTAssertEqual(3, game1.draws[0].blue)
        XCTAssertEqual(0, game1.draws[0].green)
        XCTAssertEqual(4, game1.draws[0].red)
        XCTAssertEqual(6, game1.draws[1].blue)
        XCTAssertEqual(2, game1.draws[1].green)
        XCTAssertEqual(1, game1.draws[1].red)
        XCTAssertEqual(0, game1.draws[2].blue)
        XCTAssertEqual(2, game1.draws[2].green)
        XCTAssertEqual(0, game1.draws[2].red)
        XCTAssertEqual(6, game1.maxBlue)
        XCTAssertEqual(2, game1.maxGreen)
        XCTAssertEqual(4, game1.maxRed)
        XCTAssertTrue(game1.gamePossible(blue: 14, green: 13, red: 12))
        
        // Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        let game2 = games[1]
        XCTAssertEqual(2, game2.id)
        XCTAssertEqual(3, game2.draws.count)
        XCTAssertEqual(1, game2.draws[0].blue)
        XCTAssertEqual(2, game2.draws[0].green)
        XCTAssertEqual(0, game2.draws[0].red)
        XCTAssertEqual(4, game2.draws[1].blue)
        XCTAssertEqual(3, game2.draws[1].green)
        XCTAssertEqual(1, game2.draws[1].red)
        XCTAssertEqual(1, game2.draws[2].blue)
        XCTAssertEqual(1, game2.draws[2].green)
        XCTAssertEqual(0, game2.draws[2].red)
        XCTAssertEqual(4, game2.maxBlue)
        XCTAssertEqual(3, game2.maxGreen)
        XCTAssertEqual(1, game2.maxRed)
        XCTAssertTrue(game2.gamePossible(blue: 14, green: 13, red: 12))
        
        // Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        let game3 = games[2]
        XCTAssertEqual(3, game3.id)
        XCTAssertEqual(3, game3.draws.count)
        XCTAssertEqual(6, game3.draws[0].blue)
        XCTAssertEqual(8, game3.draws[0].green)
        XCTAssertEqual(20, game3.draws[0].red)
        XCTAssertEqual(5, game3.draws[1].blue)
        XCTAssertEqual(13, game3.draws[1].green)
        XCTAssertEqual(4, game3.draws[1].red)
        XCTAssertEqual(0, game3.draws[2].blue)
        XCTAssertEqual(5, game3.draws[2].green)
        XCTAssertEqual(1, game3.draws[2].red)
        XCTAssertEqual(6, game3.maxBlue)
        XCTAssertEqual(13, game3.maxGreen)
        XCTAssertEqual(20, game3.maxRed)
        XCTAssertFalse(game3.gamePossible(blue: 14, green: 13, red: 12))
        
        // Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        let game4 = games[3]
        XCTAssertEqual(4, game4.id)
        XCTAssertEqual(3, game4.draws.count)
        XCTAssertEqual(6, game4.draws[0].blue)
        XCTAssertEqual(1, game4.draws[0].green)
        XCTAssertEqual(3, game4.draws[0].red)
        XCTAssertEqual(0, game4.draws[1].blue)
        XCTAssertEqual(3, game4.draws[1].green)
        XCTAssertEqual(6, game4.draws[1].red)
        XCTAssertEqual(15, game4.draws[2].blue)
        XCTAssertEqual(3, game4.draws[2].green)
        XCTAssertEqual(14, game4.draws[2].red)
        XCTAssertEqual(15, game4.maxBlue)
        XCTAssertEqual(3, game4.maxGreen)
        XCTAssertEqual(14, game4.maxRed)
        XCTAssertFalse(game4.gamePossible(blue: 14, green: 13, red: 12))
        
        // Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        let game5 = games[4]
        XCTAssertEqual(5, game5.id)
        XCTAssertEqual(2, game5.draws.count)
        XCTAssertEqual(1, game5.draws[0].blue)
        XCTAssertEqual(3, game5.draws[0].green)
        XCTAssertEqual(6, game5.draws[0].red)
        XCTAssertEqual(2, game5.draws[1].blue)
        XCTAssertEqual(2, game5.draws[1].green)
        XCTAssertEqual(1, game5.draws[1].red)
        XCTAssertEqual(2, game5.maxBlue)
        XCTAssertEqual(3, game5.maxGreen)
        XCTAssertEqual(6, game5.maxRed)
        XCTAssertTrue(game5.gamePossible(blue: 14, green: 13, red: 12))
        
        let sum = games.sumIsPossible(blue: 14, green: 13, red: 12)
        XCTAssertEqual(8, sum)
    }
    
    func test_sumIsPossibleWithPuzzleInput_shouldSumCorrectly() {
        let games = extractGames(puzzleInput)
        let sum = games.sumIsPossible(blue: 14, green: 13, red: 12)
        XCTAssertEqual(2879, sum)
    }
    
    // MARK: - Part II

    func test_minimumCubes() {
        let games = extractGames(sampleData)
        
        // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        let game1 = games[0]
        XCTAssertEqual(6, game1.maxBlue)
        XCTAssertEqual(2, game1.maxGreen)
        XCTAssertEqual(4, game1.maxRed)
        XCTAssertEqual(48, game1.power)
        
        // Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        let game2 = games[1]
        XCTAssertEqual(4, game2.maxBlue)
        XCTAssertEqual(3, game2.maxGreen)
        XCTAssertEqual(1, game2.maxRed)
        XCTAssertEqual(12, game2.power)
        
        // Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        let game3 = games[2]
        XCTAssertEqual(6, game3.maxBlue)
        XCTAssertEqual(13, game3.maxGreen)
        XCTAssertEqual(20, game3.maxRed)
        XCTAssertEqual(1560, game3.power)
        
        // Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        let game4 = games[3]
        XCTAssertEqual(15, game4.maxBlue)
        XCTAssertEqual(3, game4.maxGreen)
        XCTAssertEqual(14, game4.maxRed)
        XCTAssertEqual(630, game4.power)
        
        // Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        let game5 = games[4]
        XCTAssertEqual(2, game5.maxBlue)
        XCTAssertEqual(3, game5.maxGreen)
        XCTAssertEqual(6, game5.maxRed)
        XCTAssertEqual(36, game5.power)
        
        XCTAssertEqual(2286, games.sumPower)
    }

    func test_sumPowerWithPuzzleInput_shouldSumCorrectly() {
        let games = extractGames(puzzleInput)
        XCTAssertEqual(65_122, games.sumPower)
    }
    
    // MARK: - Test Data
    
    let sampleData = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """
    
    let puzzleInput = """
    Game 1: 4 red, 18 green, 15 blue; 17 green, 18 blue, 9 red; 8 red, 14 green, 6 blue; 14 green, 12 blue, 2 red
    Game 2: 6 red, 11 green; 4 blue, 4 green, 5 red; 11 green, 6 blue, 6 red
    Game 3: 3 red, 3 green; 3 green, 1 blue, 7 red; 3 green, 5 red, 1 blue; 9 red, 4 green; 1 blue, 2 green, 5 red
    Game 4: 2 blue, 5 green, 9 red; 7 red, 10 blue; 2 green, 14 blue, 5 red; 3 blue, 2 green; 4 green, 10 red, 7 blue; 2 green, 15 blue, 7 red
    Game 5: 3 red, 2 blue; 5 red, 3 blue; 10 blue, 10 red, 1 green; 4 blue
    Game 6: 1 green, 10 blue, 5 red; 8 blue, 9 green; 20 green, 7 red, 10 blue; 12 green, 6 blue, 6 red; 10 blue, 11 green; 8 blue, 17 green, 5 red
    Game 7: 7 green, 12 blue, 3 red; 19 red, 12 blue; 8 blue, 8 red, 7 green; 6 red, 7 green, 5 blue
    Game 8: 8 blue, 7 red; 13 green, 5 blue, 5 red; 11 blue, 4 green, 7 red; 5 blue, 6 red, 13 green; 7 blue, 12 green, 8 red
    Game 9: 3 red, 3 blue, 12 green; 2 red, 1 blue, 9 green; 3 red, 12 green, 3 blue; 2 red, 7 green, 2 blue; 8 green, 4 blue; 2 red, 2 green
    Game 10: 16 green, 10 red; 13 green, 7 red; 8 red, 1 blue, 8 green
    Game 11: 7 red, 1 blue, 1 green; 6 blue, 1 green, 3 red; 5 blue, 10 red
    Game 12: 1 green, 8 red, 5 blue; 6 red, 12 blue; 2 blue, 15 red; 14 blue, 15 red, 1 green; 8 red, 9 blue
    Game 13: 1 green, 6 red; 7 blue, 13 red, 1 green; 3 blue, 4 red
    Game 14: 11 red, 1 green, 1 blue; 3 blue, 18 red, 15 green; 10 blue, 5 green, 11 red
    Game 15: 6 green, 10 blue, 15 red; 6 green, 17 blue, 8 red; 19 red, 7 blue, 2 green; 1 green, 18 red, 4 blue
    Game 16: 1 green, 17 red, 7 blue; 12 red, 10 green, 9 blue; 15 red, 3 green, 15 blue
    Game 17: 12 blue, 13 green; 16 green, 19 blue, 7 red; 1 green, 2 blue
    Game 18: 8 blue, 9 green, 2 red; 9 blue, 7 green; 3 red, 9 green, 10 blue; 1 blue, 7 green, 2 red; 1 green, 8 blue, 4 red
    Game 19: 3 green, 2 red, 11 blue; 13 blue, 3 green, 1 red; 1 red, 10 blue
    Game 20: 2 red, 4 green, 1 blue; 14 blue, 7 green; 7 blue, 9 green; 4 red, 5 green, 7 blue
    Game 21: 4 blue, 20 red, 7 green; 4 green, 6 blue, 14 red; 6 green, 18 red, 5 blue; 2 blue, 4 green, 6 red; 4 green, 16 red, 4 blue
    Game 22: 13 red, 2 green; 6 red, 3 blue; 6 red, 2 green; 7 red, 1 green; 6 red, 2 green
    Game 23: 5 blue; 6 red, 16 green, 12 blue; 1 blue, 6 green, 2 red; 8 red, 6 blue, 3 green
    Game 24: 10 green, 4 blue, 5 red; 1 green, 3 red; 8 red, 3 blue, 6 green; 3 red, 2 blue; 3 red, 10 green, 3 blue
    Game 25: 1 red, 2 green; 4 green, 6 red, 1 blue; 3 red; 4 green, 2 red
    Game 26: 7 red, 1 blue; 2 red, 1 blue; 9 red, 1 green, 2 blue; 5 red, 2 blue; 4 red, 2 green; 8 red, 1 green, 2 blue
    Game 27: 1 green, 2 red, 8 blue; 1 green, 4 red, 9 blue; 16 blue, 12 red, 3 green; 13 blue, 4 green, 5 red
    Game 28: 8 blue, 8 green, 3 red; 8 green, 6 blue; 5 green, 6 blue, 4 red
    Game 29: 7 red, 11 green, 5 blue; 1 green, 1 blue, 6 red; 6 green, 5 blue, 8 red; 7 blue, 15 green, 2 red; 10 blue, 1 red
    Game 30: 7 red, 5 blue, 14 green; 2 blue, 11 red; 17 green, 2 blue, 7 red; 4 blue, 10 red, 5 green
    Game 31: 17 blue, 5 red, 2 green; 7 red, 14 blue, 3 green; 13 blue, 5 red, 2 green; 12 green, 8 blue, 8 red
    Game 32: 1 red, 7 blue; 1 red, 8 blue; 1 red, 2 green, 13 blue
    Game 33: 1 green, 3 blue, 3 red; 4 red, 2 green; 5 blue, 1 red, 1 green; 1 red, 8 blue, 2 green
    Game 34: 9 blue, 7 red; 9 green, 11 red, 1 blue; 18 red, 4 blue, 6 green
    Game 35: 7 blue, 4 green, 2 red; 1 green, 1 blue, 2 red; 3 green; 3 blue, 7 green, 1 red; 7 blue, 12 green
    Game 36: 17 red, 5 blue; 6 red, 5 green, 7 blue; 16 blue, 1 green, 7 red; 7 blue, 5 green, 15 red; 8 blue, 19 red, 1 green
    Game 37: 4 blue, 6 red, 1 green; 9 red, 8 green, 4 blue; 1 green, 8 blue, 10 red; 11 green, 6 red, 9 blue
    Game 38: 3 red, 4 blue; 5 red, 1 blue; 1 green, 2 red, 5 blue; 2 blue, 8 red; 7 red, 1 blue; 4 blue, 5 red
    Game 39: 7 green; 5 green; 3 blue; 12 green, 1 red, 1 blue; 8 green, 1 blue, 1 red
    Game 40: 12 red, 11 blue; 6 green, 2 blue, 13 red; 6 green, 7 red, 6 blue
    Game 41: 3 green, 1 blue; 5 blue, 7 red, 6 green; 6 red, 14 blue; 9 red, 14 green, 5 blue; 5 blue, 6 green, 3 red; 20 green, 4 blue, 5 red
    Game 42: 2 blue, 13 green; 10 red, 6 green; 8 green, 2 red; 7 red
    Game 43: 7 green, 3 red; 6 red, 6 green, 13 blue; 7 green, 2 red, 9 blue; 8 blue, 3 green, 1 red; 10 green, 7 red, 13 blue
    Game 44: 3 blue, 1 green, 2 red; 10 blue, 9 red; 5 red, 13 blue
    Game 45: 11 red, 2 green, 5 blue; 1 green, 6 red, 6 blue; 17 red, 2 green, 6 blue; 14 red, 2 green
    Game 46: 5 blue, 7 red, 8 green; 6 green, 1 red, 10 blue; 1 red, 5 blue, 4 green
    Game 47: 5 green, 5 red, 1 blue; 11 green, 8 red, 6 blue; 2 green, 16 red, 1 blue; 12 green, 1 red, 7 blue; 2 red, 15 green, 7 blue
    Game 48: 3 red, 6 green, 4 blue; 1 blue, 1 green, 2 red; 12 blue, 7 green, 5 red
    Game 49: 4 blue, 1 green; 4 red, 2 blue; 3 blue, 2 green; 5 red, 3 blue, 4 green
    Game 50: 1 blue, 1 green; 3 blue, 7 red, 1 green; 2 blue, 1 green
    Game 51: 17 blue, 1 green, 3 red; 2 green, 1 red, 3 blue; 14 blue, 10 red
    Game 52: 8 blue, 1 green; 1 blue, 3 red, 2 green; 2 green, 14 blue
    Game 53: 9 green, 3 blue, 9 red; 3 blue, 7 red, 8 green; 2 green, 2 red; 17 green, 3 red; 18 green, 8 red
    Game 54: 2 blue, 10 red; 2 green, 2 red; 6 green, 1 blue, 1 red; 3 blue, 6 red, 7 green
    Game 55: 3 blue, 1 red; 1 green, 2 red, 1 blue; 4 blue, 3 red; 5 blue, 3 green; 3 green, 1 red, 3 blue; 2 green
    Game 56: 10 green, 1 red, 6 blue; 16 green, 1 blue, 10 red; 8 red, 9 green, 2 blue; 3 red, 2 blue
    Game 57: 1 blue, 4 green, 1 red; 7 red, 4 green, 8 blue; 9 red, 3 blue, 3 green
    Game 58: 15 green, 16 blue, 8 red; 8 blue, 8 red, 2 green; 9 blue, 8 red, 3 green; 20 blue, 15 green, 7 red
    Game 59: 13 red, 3 blue; 12 red, 4 green; 9 blue, 5 green, 9 red; 2 red, 12 blue, 1 green
    Game 60: 14 green, 16 red; 5 green, 1 blue, 5 red; 14 green, 5 blue, 20 red; 2 blue, 8 green, 1 red
    Game 61: 2 green, 10 red, 15 blue; 17 blue, 6 red, 2 green; 2 red, 2 green, 12 blue; 2 red, 2 green
    Game 62: 8 blue, 1 green, 3 red; 6 red, 15 blue, 2 green; 5 green, 6 blue; 1 red, 7 green, 8 blue
    Game 63: 13 green, 8 red; 8 green, 1 blue, 5 red; 2 green, 8 red, 2 blue
    Game 64: 13 red, 12 blue, 4 green; 2 blue, 3 red, 1 green; 4 green, 14 red, 14 blue; 8 red, 4 green; 16 red; 5 blue, 16 red, 4 green
    Game 65: 13 red, 2 blue, 3 green; 10 red, 6 blue; 6 blue, 5 red
    Game 66: 1 blue, 9 green; 4 green, 5 blue; 8 green, 8 blue; 10 blue, 1 red, 10 green; 18 blue, 1 red, 9 green
    Game 67: 12 red, 7 blue; 13 red, 3 blue, 3 green; 7 blue, 6 red, 4 green
    Game 68: 3 green, 4 blue, 8 red; 1 green, 2 blue, 13 red; 3 green, 14 red, 4 blue; 6 red, 4 green; 7 blue, 2 red, 1 green; 1 green, 3 blue, 14 red
    Game 69: 2 blue, 6 red, 2 green; 7 green, 18 red; 11 green, 1 blue, 13 red; 3 red, 6 green, 1 blue; 19 red, 1 green
    Game 70: 13 green; 1 red, 14 green, 2 blue; 9 red, 1 blue, 9 green; 6 green, 5 red, 1 blue; 2 green, 10 red
    Game 71: 7 blue, 5 green, 11 red; 4 red, 8 blue, 5 green; 1 green, 1 blue; 6 green, 8 red, 5 blue; 8 red, 7 green, 6 blue
    Game 72: 2 blue, 2 green, 1 red; 5 green, 1 red, 3 blue; 4 green
    Game 73: 8 green, 3 blue, 3 red; 1 green, 3 red, 9 blue; 3 red, 10 blue, 8 green; 10 green, 3 red, 8 blue; 3 blue, 3 green; 2 green
    Game 74: 5 red, 1 green; 1 blue, 5 red; 8 red, 3 blue
    Game 75: 5 red, 7 green, 3 blue; 1 red, 5 blue, 4 green; 2 blue, 12 green; 3 blue, 5 red; 8 green, 4 blue, 3 red; 1 green, 2 blue, 1 red
    Game 76: 10 green, 5 blue, 1 red; 11 blue, 16 green, 1 red; 12 blue, 2 red, 18 green; 12 green, 10 blue; 5 blue, 5 green, 1 red; 9 green, 1 red, 1 blue
    Game 77: 9 blue, 1 red, 2 green; 1 blue, 1 red, 5 green; 5 blue
    Game 78: 1 red, 1 blue; 1 blue; 1 red; 1 green, 2 red, 1 blue; 1 blue, 4 red
    Game 79: 3 green, 11 red, 4 blue; 7 red, 1 green, 4 blue; 1 green, 3 red, 3 blue; 3 blue, 3 red, 4 green; 3 green, 3 blue, 9 red
    Game 80: 11 blue, 10 green, 11 red; 10 green, 9 red, 18 blue; 11 green, 17 blue, 7 red
    Game 81: 6 red, 1 blue; 3 blue, 6 red, 2 green; 6 red, 10 green, 1 blue; 5 blue, 3 green, 3 red
    Game 82: 6 red, 16 green, 2 blue; 9 green, 6 red, 3 blue; 1 blue, 9 red, 14 green; 8 green, 11 red, 3 blue; 3 red, 5 green; 12 green, 3 blue
    Game 83: 7 blue, 5 green, 11 red; 8 red, 9 blue, 13 green; 13 blue, 8 red, 8 green; 2 blue, 9 green, 5 red
    Game 84: 9 green, 14 red, 11 blue; 1 green, 12 blue, 6 red; 12 green, 10 red, 7 blue; 15 green, 6 blue; 15 blue, 4 red, 6 green; 16 green, 2 red, 13 blue
    Game 85: 7 red, 7 blue, 3 green; 5 green, 1 blue; 6 red, 11 green, 7 blue
    Game 86: 9 green, 6 blue, 6 red; 3 red, 2 blue, 7 green; 4 red, 4 green, 7 blue; 10 blue, 10 green, 2 red; 5 green
    Game 87: 6 green, 5 blue; 15 blue, 9 green, 1 red; 14 blue, 15 green
    Game 88: 3 blue, 2 green, 5 red; 8 blue, 1 green, 2 red; 5 red, 8 blue, 1 green; 1 red, 1 blue; 1 green, 6 red, 2 blue; 1 green, 2 red, 1 blue
    Game 89: 4 blue, 3 green; 1 blue, 2 red; 2 red, 1 green, 4 blue; 2 red, 2 blue, 1 green
    Game 90: 2 green, 1 red; 3 green, 8 red; 1 blue, 6 red, 4 green
    Game 91: 3 red; 1 blue, 6 red; 1 blue, 5 red, 1 green
    Game 92: 6 red, 9 green, 7 blue; 9 green, 4 red; 2 green, 5 blue
    Game 93: 7 green, 1 red; 3 blue, 3 red; 3 green, 9 red, 4 blue; 2 red, 6 green; 5 red, 3 blue
    Game 94: 4 green, 11 red; 13 green, 9 red; 16 green, 11 red; 6 green, 2 blue, 14 red; 17 green, 9 red
    Game 95: 7 red, 13 blue, 2 green; 8 green, 13 blue, 3 red; 5 green, 6 red, 13 blue; 8 green, 8 blue, 2 red; 6 blue, 4 green, 8 red; 2 blue, 2 red
    Game 96: 10 red, 3 blue, 3 green; 2 blue, 4 green, 5 red; 7 blue, 4 green, 6 red; 1 green, 4 red, 5 blue
    Game 97: 5 red, 8 blue; 4 green, 2 red, 14 blue; 10 blue, 7 green
    Game 98: 1 red, 2 green, 14 blue; 6 green, 1 blue; 19 blue, 4 red; 18 blue, 4 red, 3 green; 2 red, 1 blue
    Game 99: 3 red, 4 blue; 7 red, 5 blue, 3 green; 2 green, 1 blue, 1 red; 4 blue, 2 green, 1 red; 1 green, 1 red, 2 blue; 1 green, 6 blue, 7 red
    Game 100: 2 blue, 10 green; 10 green, 14 red; 3 green, 5 red, 2 blue; 1 red, 3 blue, 7 green; 1 blue, 7 red
    """
}

//Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
//Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
//Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
//Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

//The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?

//Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?

