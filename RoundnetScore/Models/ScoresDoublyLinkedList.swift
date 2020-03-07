//
//  ScoresDoublyLinkedList.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 06/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class ScoresDoublyLinkedList<Player>: CustomStringConvertible {
    private var head: Score<Player>? = nil
    private var tail: Score<Player>? = nil

    public var first: Player? { head?.scoringPlayer }
    public var last: Player? { tail?.scoringPlayer }
    public var isEmpty: Bool { head == nil }

    var description: String {
        guard let head = head else { return "Empty list" }
        return String(describing: head)
    }

    init() {
        head = nil
        tail = head
    }

    func deleteAll() {
        head = nil
        tail = nil
    }

//    subscript(index: Int) -> Score<T>? {
//        node(at: index)
//    }

//    Get all values in forward direction
    public var forwardValues: [Player]? {
        if isEmpty { return nil }
        var values: [Player] = []
        var currentNode = head
        while currentNode != nil {
            values.append(currentNode!.scoringPlayer!)
            currentNode = currentNode?.next
        }

        return values
    }

    public var backwardValues: [Player]? {
        guard let tailNode = tail else { return nil }

        var values: [Player] = []
        var previousNode = tailNode
        repeat {
            values.append(previousNode.scoringPlayer!)
            if let previous = previousNode.previous {
                previousNode = previous
            }
        } while previousNode.previous != nil
        return values
    }

//    public func score(_ value: T) {
//        let newScore = Score(
//
//    }




}
