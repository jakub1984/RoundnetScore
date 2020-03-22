//
//  Game+CoreDataProperties.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 22/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var maxPoints: Int16
    @NSManaged public var numberOfPlayers: Int16

}
