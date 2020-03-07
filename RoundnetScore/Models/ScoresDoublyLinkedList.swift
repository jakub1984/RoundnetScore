//
//  ScoresDoublyLinkedList.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 06/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class ScoresDoublyLinkedList<Point>: CustomStringConvertible {
    private var head: Score<Point>? = nil
    private var tail: Score<Point>? = nil

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

//    subscript(index: Int) -> Score<Point>? {
//        node(at: index)
//    }

//    Get all values in forward direction
    public var forwardValues: [Point]? {
        if isEmpty { return nil }
        var values: [Point] = []
        var currentNode = head
        while currentNode != nil {
            values.append(currentNode!.value)
            currentNode = currentNode?.next
        }

        return values
    }

    public var backwardValues: [Point]? {
        guard let tailNode = tail else { return nil }

        var values: [Point] = []
        var previousNode = tailNode
        repeat {
            values.append(previousNode.value)
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
