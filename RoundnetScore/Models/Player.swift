//
//  Player.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 28/12/2019.
//  Copyright © 2019 com.jakubperich. All rights reserved.
//

import Foundation

enum Team: String, CaseIterable {
    case home = "Home is winner"
    case away = "Away is winner"
    case noTeam = "Nobody is winner"

    var wins: String {
        switch self {
        case .home: return "Home wins"
        case .away: return "Away wins"
        case .noTeam: return "Nobody wins"
        }
    }
}

enum Position: CaseIterable {
    case A
    case B
}

struct Player {
    var isServing: Bool = false
    let team: Team
    var position: Position? = nil

    init(team: Team, position: Position? = nil) {
        self.team = team
        self.position = position
    }
}
