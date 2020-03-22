//
//  PlayerCoreData+CoreDataProperties.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 22/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerCoreData> {
        return NSFetchRequest<PlayerCoreData>(entityName: "PlayerCoreData")
    }

    @NSManaged public var name: String

}
