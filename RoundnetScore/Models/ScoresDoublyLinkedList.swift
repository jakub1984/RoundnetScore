//
//  ScoresDoublyLinkedList.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 06/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class ScoresDoublyLinkedList<T>: CustomStringConvertible {
    private var head: Score<T>? = nil
    private var tail: Score<T>? = nil

    public var first: T? { head?.value }
    public var last: T? { tail?.value }
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
    public var forwardValues: [T]? {
        if isEmpty { return nil }
        var values: [T] = []
        var currentNode = head
        while currentNode != nil {
            values.append(currentNode!.value)
            currentNode = currentNode?.next
        }

        return values
    }

    public var backwardValues: [T]? {
        guard let tailNode = tail else { return nil }

        var values: [T] = []
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
