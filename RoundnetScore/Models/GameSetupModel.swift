//
//  SettingsViewModel.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 02/01/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class GameSetupModel {
    public var players: [Player] = [Player(position: .NO)]
    public var numberOfPlayers: Int
    public var numberOfSets: Int
    public var maxPoints: Int
    private let maxPlayers: Int

    init() {
        self.numberOfSets = 3
        self.numberOfPlayers = 4
        self.maxPoints = 15
        self.maxPlayers = 4
        self.getPlayers(playersCount: numberOfPlayers)
    }

    private func getPlayers(playersCount: Int) {
        guard playersCount <= maxPlayers else {
            print("Error: Trying to create more players than maximum number of players")
            return
        }
        for id in 1...playersCount {
            self.players.append(Player(id: id))
        }
        print("Players created: \(self.players)")
    }
}
