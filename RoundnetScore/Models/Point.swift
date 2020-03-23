//
//  Point.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 22/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

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
