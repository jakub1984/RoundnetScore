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
    
    var positionId: Int {
        switch self {
        case .A: return 1
        case .B: return 2
        case .C: return 3
        case .D: return 4
        case .NO: return 0
        }
    }
}

public struct Player: Equatable {
    var position: Position = .NO
    var isServing: Bool = false
    var team: Team = .noTeam
    var id: Int = 0

    init(position: Position) {
        self.position = position
        self.team = getTeam(position: self.position)
        self.id = getPlayerId(position: self.position)
    }

    init(id: Int) {
        self.position = getPositionByID(id)
        self.team = getTeam(position: self.position)
        self.id = id
    }

    private func getPlayerId(position: Position) -> Int {
        switch position {
        case .NO: return 0
        case .A: return 1
        case .B: return 2
        case .C: return 3
        case .D: return 4
        }
    }

    private func getPositionByID(_ id: Int) -> Position {
        switch id {
        case 0: return .NO
        case 1: return .A
        case 2: return .B
        case 3: return .C
        case 4: return .D
        default:
            print("Invalid Player ID")
            return .NO
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
