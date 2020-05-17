//
//  LinkedListStorage.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

import BaseSwift

extension LinkedList {

    internal final class LinkedListStorage {
        internal let copyOnWriteMutex = UnfairLock()

        internal var head: Node?
        internal var tail: Node?

        internal var allNodes: [Node] {
            self.head.map { Array($0) } ?? []
        }

        internal init(_ nodes: [Node]? = nil) {
            nodes?.forEach { self.append($0.instanceForListMutation().element) }
        }

        @inlinable deinit {
            self.removeAll()
        }

        @inlinable internal func append(_ element: Element) {
            _ = self.insert(element: element, before: nil)
        }

        internal func insert(element: Element, before next: Node?) -> Node {
            assert(type(of: element) != Node.self)    // LinkedList.Node must be overridden
            let node = element as? Node ?? ComposedNode(element)
            self.insert(node: node, before: next)
            return node
        }

        internal func insert(node: Node, before next: Node?) {
            precondition(node.next == nil && node.previous == nil, "LinkedList inserting existing child node")

            if let next = next {
                node.next = next
                node.previous = next.previous
                next.previous = node
            } else {
                node.previous = self.tail
                self.tail = node
            }

            node.previous?.next = node
            if next === self.head { self.head = node }
        }

        internal func remove(_ node: Node?, count: Int = 1) {
            var nextNode = node
            var remainingCount = count
            while let removeNode = nextNode, remainingCount > 0 {
                nextNode = removeNode.next
                remainingCount -= 1

                removeNode.previous?.next = removeNode.next
                removeNode.next?.previous = removeNode.previous

                if self.head === removeNode { self.head = removeNode.next }
                if self.tail === removeNode { self.tail = removeNode.previous }

                removeNode.next = nil
                removeNode.previous = nil
            }
        }

        internal func reverse() {
            var nextNode: Node? = self.tail
            while let node = nextNode {
                swap(&node.next, &node.previous)
                nextNode = node.next
            }

            swap(&self.head, &self.tail)
        }

        internal func removeAll() {
            var nextNode = self.head
            while let node = nextNode {
                nextNode = node.next
                node.next = nil
            }

            self.head = nil
            self.tail = nil
        }

        internal func singleToDoubleLinkedList(_ head: Node?) {
            var nextNode = head
            var previousNode: Node?
            while let node = nextNode {
                node.previous = previousNode
                nextNode = node.next
                previousNode = node
            }

            self.head = head
            self.tail = previousNode
        }
    }
}

extension LinkedList.LinkedListStorage: Equatable {

    internal static func == (lhs: LinkedList.LinkedListStorage, rhs: LinkedList.LinkedListStorage) -> Bool {
        lhs === rhs
    }
}
