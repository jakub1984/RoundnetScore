//
//  Point.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 22/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

public struct Point: Equatable {
    let home: Int
    let away: Int
    let server: Player?
    let receiver: Player?

    init(home: Int, away: Int, currentServer: Player? = nil, currentReceiver: Player? = nil) {
        self.home = home
        self.away = away
        self.server = currentServer
        self.receiver = currentReceiver
    }

    public static func == (lhs: Point, rhs: Point) -> Bool {
        (lhs.home + lhs.away) == (rhs.home + rhs.away)
    }
}
