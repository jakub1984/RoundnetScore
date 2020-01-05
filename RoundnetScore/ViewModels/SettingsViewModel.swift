//
//  SettingsViewModel.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 02/01/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class SettingsViewModel {
    public var numberOfSets: Int
    public var players: [Player]
    public var numberOfPlayers: Int
    public var maxPoints: Int

    init() {
        self.numberOfSets = 3
        self.players = [
            Player(team: .noTeam, position: .NO),
            Player(team: .home, position: .A),
            Player(team: .away, position: .A),
            Player(team: .home, position: .B),
            Player(team: .away, position: .B)
        ]
        self.numberOfPlayers = players.count - 1
        self.maxPoints = 15
    }

    private func setNumberOfPlayers(players: Int) {
        if players < 4 {
            self.players = [
            Player(team: .noTeam, position: .NO),
            Player(team: .home, position: .A),
            Player(team: .away, position: .A)
            ]
        } else {
            self.players = [
                Player(team: .noTeam, position: .NO),
                Player(team: .home, position: .A),
                Player(team: .away, position: .A),
                Player(team: .home, position: .B),
                Player(team: .away, position: .B)
            ]
        }
    }

    private func setMaxScore(score: Int) {
        return self.maxPoints = score
    }
}
