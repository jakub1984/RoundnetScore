//
//  Score.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 29/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import Foundation

class Score: CustomStringConvertible, Equatable {

    let value: Point

    var next: Score?
    weak var previous: Score?

    var description: String {
        guard let next = next else { return "\(value)"}
        return "\(value) -> " + String(describing: next)
    }

    init(_ value: Point, prev: Score?, next: Score?) {
        self.value = value
        self.previous = prev
        self.next = next
    }

    static func == (lhs: Score, rhs: Score) -> Bool {
        lhs.next == rhs.next
    }
}

public struct Point: Equatable {
    let home: Int
    let away: Int
    let scoringPlayer: Player?
    let currentReceiver: Player?

    init(home: Int, away: Int, scoringPlayer: Player? = nil, currentReceiver: Player? = nil) {
        self.home = home
        self.away = away
        self.scoringPlayer = scoringPlayer
        self.currentReceiver = currentReceiver
    }

    public static func == (lhs: Point, rhs: Point) -> Bool {
        (lhs.home + lhs.away) == (rhs.home + rhs.away)
    }
}
