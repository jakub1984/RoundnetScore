//
//  GameViewModel.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 06/01/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class GameViewModel {

    var scoreHistory: [Score] = []
    var server: Player = Player(team: .noTeam, position: .NO)

}
