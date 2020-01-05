//
//  GameViewModel.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 02/01/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class GameViewModel {
    var numberOfSets: Int = 1
    var players: [Player]
    var maxPoints: Int = 15
    var currentServer: Player

    init(settings: SettingsViewModel) {
        self.numberOfSets = settings.numberOfSets
        self.players = settings.players
        self.maxPoints = settings.maxPoints
        self.currentServer = players[0]
    }

}
