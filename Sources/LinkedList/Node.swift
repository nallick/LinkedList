//
//  Node.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//
//  LinkedList.Node can be subclassed to provide custom list nodes (e.g., class CustomNode: LinkedList<CustomNode>.Node {} ).
//  However this means any reordering of the list invalidates existing indices. This is mostly acceptable but can be a problem for some default implementations.
//  For example, MutableCollection.partition() swaps nodes then reuses existing indices, likely causing a crash.
//

import BaseSwift

extension LinkedList {

    open class Node {
        public internal(set) var next: Node?
        public internal(set) unowned var previous: Node?

        @inlinable public var element: ElementType { self as! ElementType }   // Note: this class must be overridden

        @inlinable public init() {}

        open func instanceForListMutation() -> Node { fatalError("Node.instanceForListMutation must be overriden") }

        internal func updateElement(_ newElement: ElementType, in list: LinkedListStorage) {
            let newNode = newElement as! Node
            newNode.previous = self.previous
            newNode.next = self.next
            newNode.previous?.next = newNode
            newNode.next?.previous = newNode
            self.previous = nil
            self.next = nil
            if self === list.head { list.head = newNode }
            if self === list.tail { list.tail = newNode }
        }
    }

    internal final class ComposedNode: Node {
        private var composedElement: ElementType

        @inlinable public override var element: ElementType { self.composedElement }

        internal init(_ element: ElementType) { self.composedElement = element }

        internal override func instanceForListMutation() -> Node { return self }

        internal override func updateElement(_ newElement: ElementType, in list: LinkedListStorage) {
            self.composedElement = newElement
        }
    }
}

extension LinkedList.Node: Equatable {

    @inlinable public static func == (lhs: LinkedList.Node, rhs: LinkedList.Node) -> Bool { lhs === rhs }
}

extension LinkedList.Node: Sequence {

    public func makeIterator() -> AnyIterator<LinkedList.Node> {
        var current: LinkedList.Node? = self
        return AnyIterator {
            let result = current
            current = current?.next
            return result
        }
    }
}
