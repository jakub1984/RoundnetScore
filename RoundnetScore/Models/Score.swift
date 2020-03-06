//
//  Score.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 29/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import Foundation

class Score<T>: CustomStringConvertible, Equatable {

    var value: T
    let home: Int
    let away: Int
    let scoringPlayer: Player?
    let receivingPlayer: Player?

    var next: Score<T>?
    weak var previous: Score<T>?

    var description: String {
        guard let next = next else { return "\(value)"}
        return "\(value) -> " + String(describing: next)
    }

    init(home: Int, away: Int, scoringPlayer: Player? = nil, currentReceiver: Player? = nil, prev: Score<T>? = nil, next: Score<T>? = nil, value: T) {
        self.home = home
        self.away = away
        self.scoringPlayer = scoringPlayer
        self.receivingPlayer = currentReceiver
        self.value = value
        self.previous = prev
        self.next = next
    }

    static func == (lhs: Score<T>, rhs: Score<T>) -> Bool {
        (lhs.home + lhs.away) == (rhs.home + rhs.away)
    }
}
