//
//  Score.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 29/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import Foundation

struct Score {
    let home: Int
    let away: Int
    let scoringPlayer: Player?
    let receivingPlayer: Player?

    init(home: Int, away: Int, scoringPlayer: Player? = nil, currentReceiver: Player? = nil) {
        self.home = home
        self.away = away
        self.scoringPlayer = scoringPlayer
        self.receivingPlayer = currentReceiver
    }
}
