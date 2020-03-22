//
//  ScoresDoublyLinkedList.swift
//  RoundnetScore
//
//  Created by Jakub Perich on 06/03/2020.
//  Copyright © 2020 com.jakubperich. All rights reserved.
//

import Foundation

class ScoresDoublyLinkedList: CustomStringConvertible {
    public var head: Score? = nil
    public var tail: Score? = nil

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

    public func append(_ value: Point) {
        let newPoint = Score(value, prev: nil, next: nil)
        if let tail = tail {
            newPoint.previous = tail
            tail.next = newPoint
        } else {
            head = newPoint
        }
        tail = newPoint
    }

    @discardableResult
    public func deleteLast() -> Point? {
        guard var tailNode = tail, var headNode = head else { return nil }
        defer {
            if tailNode == headNode {
                tail = nil
                head = nil
            } else if let prev = tailNode.previous {
                tail = prev
                tail?.next = nil
            }
        }
        return tailNode.value
    }

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

//    Get a score from a specific position
    func node(at index: Int) -> Score? {
        if isEmpty { return nil }
        if index >= 0 {
            var currentNode = head
            var currentIndex = 0
            while currentNode != nil && currentIndex < index {
                currentNode = currentNode?.next
                currentIndex += 1
            }
            return currentNode
        }
        return nil
    }

//    Access a node using subscript operation
    subscript(index: Int) -> Score? {
        node(at: index)
    }

//    Get number of scores
    func count() -> Int {
        var currentNode = head
        var scoreCount = 0
        while currentNode != nil {
            scoreCount += 1
            currentNode = currentNode?.next
        }
        return scoreCount
    }
}
