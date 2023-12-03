//
//  Day_02.swift
//  AdventOfCode2023
//
//  Created by David Taylor on 02/12/2023.
//

import Foundation

// MARK: - Part I

public struct Draw {
    public let blue: Int
    public let green: Int
    public let red: Int
    
    static func from(_ data: String) -> Draw {
        let drawItems = data.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        var blue: Int = 0
        var green: Int = 0
        var red: Int = 0
        for drawItem in drawItems {
            let scanner = Scanner(string: drawItem)
            let number = scanner.scanInt()!
            let color = scanner.scanUpToString(" ")
            if color == "blue" {
                blue = number
            } else if color == "green" {
                green = number
            } else if color == "red" {
                red = number
            }
        }
        return Draw(blue: blue, green: green, red: red)
    }
}

public struct Game {
    public let id: Int
    public let draws: [Draw]
    
    public init(id: Int, draws: [Draw]) {
        self.id = id
        self.draws = draws
    }
    
    var maxBlue: Int {
        draws.map { $0.blue }.max() ?? 0
    }
    
    var maxGreen: Int {
        draws.map { $0.green }.max() ?? 0
    }
    
    var maxRed: Int {
        draws.map { $0.red }.max() ?? 0
    }
    
    var power: Int {
        maxBlue * maxGreen * maxRed
    }
    
    func gamePossible(blue: Int, green: Int, red: Int) -> Bool {
        return maxBlue <= blue &&
        maxGreen <= green &&
        maxRed <= red
    }
}

extension Array where Element == Game {
    func sumIsPossible(blue: Int, green: Int, red: Int) -> Int {
        filter { $0.gamePossible(blue: blue, green: green, red: red) }
            .map(\.id)
            .reduce(0, +)
    }
    
    var sumPower: Int {
        map(\.power)
            .reduce(0, +)
    }
}

public func extractGames(_ data: String) -> [Game] {
    let rowData = data.split(whereSeparator: \.isNewline).map { String($0) }
    var games = [Game]()
    for row in rowData {
        let (gameId, remainder) = row.extractGameIdAndRemainder
        let drawData = remainder.split(separator: ";").map { String($0) }
        var draws = [Draw]()
        drawData.map(\.extractDraw)
            .forEach { draws.append($0) }
        games.append(Game(id: gameId, draws: draws))
    }
    return games
}

private extension String {
    var extractGameIdAndRemainder: (Int, String) {
        let scanner = Scanner(string: self)
        _ = scanner.scanString("Game ")
        let gameId = scanner.scanInt()!
        _ = scanner.scanString(": ")
        let remainder = scanner.scanUpToCharacters(from: .newlines)!
        return (gameId, remainder)
    }
    
    // Move to method on Draw - draw(from: String) ?
    var extractDraw: Draw {
        let drawItems = split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        var blue: Int = 0
        var green: Int = 0
        var red: Int = 0
        for drawItem in drawItems {
            let scanner = Scanner(string: drawItem)
            let number = scanner.scanInt()!
            let color = scanner.scanUpToString(" ")
            if color == "blue" {
                blue = number
            } else if color == "green" {
                green = number
            } else if color == "red" {
                red = number
            }
        }
        return Draw(blue: blue, green: green, red: red)
    }
}

//Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
//Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
//Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
//Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green


// MARK: Alternative
// https://github.com/FieryFlames/AdventOfCode/blob/2023/Sources/Day02.swift
// https://github.com/rizwankce/AdventOfCode/blob/master/2023/Sources/Day02.swift

