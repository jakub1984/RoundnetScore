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
    let winningScore: String
    let maxSets: Int = 1
    let sets: [Score]

    init(server: Player, sets: [Score], final: Bool = false) {
        self.server = server
        self.sets = sets

        let homeScore = sets.last!.home
        let awayScore = sets.last!.away
        self.winningTeam = homeScore > awayScore ? .home : .away
        self.winningScore = "\(homeScore) : \(awayScore)"
    }
}
