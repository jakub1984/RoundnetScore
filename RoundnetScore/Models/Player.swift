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
    case C
    case D
    case NO
}

public struct Player: Equatable {
    var position: Position
    var isServing: Bool = false
    var team: Team = .noTeam
    var id: Int = 0

    init(position: Position) {
        self.position = position
        self.team = getTeam(position: self.position)
        self.id = getPlayerId(position: self.position)
    }

    private func getPlayerId(position: Position) -> Int {
        switch position {
        case .A: return 1
        case .B: return 2
        case .C: return 3
        case .D: return 4
        case .NO: return 0
        }
    }

    private func getTeam(position: Position) -> Team {
        switch position {
        case .A: return .home
        case .B: return .away
        case .C: return .home
        case .D: return .away
        case .NO: return .noTeam
        }
    }

    public static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }

}
