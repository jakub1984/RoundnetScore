//
//  Score.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 29/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import Foundation

class Score<Player>: CustomStringConvertible, Equatable {

    let home: Int
    let away: Int
    let scoringPlayer: Player?
    let receivingPlayer: Player?

    var next: Score<Player>?
    weak var previous: Score<Player>?

    var description: String {
        guard let next = next else { return "\(scoringPlayer)"}
        return "\(scoringPlayer) -> " + String(describing: next)
    }

    init(home: Int, away: Int, scoringPlayer: Player? = nil, currentReceiver: Player? = nil, prev: Score<Player>? = nil, next: Score<Player>? = nil) {
        self.home = home
        self.away = away
        self.scoringPlayer = scoringPlayer
        self.receivingPlayer = currentReceiver
        self.previous = prev
        self.next = next
    }

    static func == (lhs: Score<Player>, rhs: Score<Player>) -> Bool {
        (lhs.home + lhs.away) == (rhs.home + rhs.away)
    }
}
