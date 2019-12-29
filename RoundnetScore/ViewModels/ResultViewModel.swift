//
//  ResultViewModel.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 29/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import Foundation

class ResultViewModel {
    let winningTeam: Team
    let server: Player
    let scores: [Score]
    let winningScore: String

    init(server: Player, scores: [Score]) {
        self.server = server
        self.scores = scores

        self.winningTeam = scores.last!.home > scores.last!.away ? .home : .away
        self.winningScore = "\(scores.last!.home) : \(scores.last!.away)"
    }

}
