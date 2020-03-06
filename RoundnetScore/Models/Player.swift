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
        case .home: return "HOME TEAM"
        case .away: return "AWAY TEAM"
        case .noTeam: return "Nobody wins"
        }
    }
}

enum Position: CaseIterable {
    case A
    case B
    case NO
}

struct Player: Equatable {
    var isServing: Bool = false
    let team: Team
    let position: Position
    var id: Int = 0

    init(team: Team, position: Position) {
        self.team = team
        self.position = position
        self.id = self.getPlayerId(team: team, position: position)
    }

    private func getPlayerId(team: Team, position: Position) -> Int {
        switch (team, position) {
        case (.home, .A): return 1
        case (.away, .A): return 2
        case (.home, .B): return 3
        case (.away, .B): return 4
        default: return 0
        }
    }

    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }

}
