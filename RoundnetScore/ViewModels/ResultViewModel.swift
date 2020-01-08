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
    var homeSets: Int = 0
    var awaySets: Int = 0

    init(server: Player, sets: [Score], final: Bool = false) {
        self.server = server
        self.sets = sets

        let homeScore = sets.last!.home
        let awayScore = sets.last!.away
        self.winningTeam = homeScore > awayScore ? .home : .away
        self.winningScore = "\(homeScore) : \(awayScore)"
        getSetsResult()
    }

    private func getSetsResult() {
        sets.forEach { score in
            if score.home > score.away {
                homeSets += 1
            } else {
                awaySets += 1
            }
        }
    }

    func getSetsScoreLabel() -> String {
        if sets.count == maxSets {
            return "GAME: \(homeSets):\(awaySets)"
        } else {
            return "SETS:"
        }
    }

    func getGameScoreLabel() -> String {
        return "\(sets.last?.home ?? 0):\(sets.last?.away ?? 0)"
    }

    func getNextGameButtonLabel() -> String {
        return sets.count == maxSets ? "NEW GAME" : "NEXT SET"
    }

    func getSetsHistoryLabel() -> String {
        guard sets.count > 1 else { return ""}
        return "TODO - add sets history"
    }
}
