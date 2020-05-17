//
//  BidirectionalCollection.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: BidirectionalCollection {

    public struct Index: Comparable {
        internal let offset: Int
        internal let node: Node?
        internal let parent: LinkedListStorage

        public static func < (lhs: Index, rhs: Index) -> Bool { lhs.offset < rhs.offset }
    }

    public var startIndex: Index { Index(offset: 0, node: self.storage.head, parent: self.storage) }

    public var endIndex: Index { Index(offset: self.count, node: nil, parent: self.storage) }

    public func distance(from start: Index, to end: Index) -> Int {
        end.offset - start.offset
    }

    public func index(before index: Index) -> Index {
        Index(offset: index.offset - 1, node: self.optionalNode(at: index)?.previous ?? self.tail, parent: self.storage)
    }

    public func index(after index: Index) -> Index {
        Index(offset: index.offset + 1, node: self.optionalNode(at: index)?.next, parent: self.storage)
    }

    public func index(for node: Node) -> Index? {
        guard var currentNode = self.head else { return nil }

        for offset in 0 ..< self.count {
            if currentNode === node { return Index(offset: offset, node: node, parent: self.storage) }
            guard let nextNode = currentNode.next else { break }
            currentNode = nextNode
        }

        return nil
    }

    public func makeIterator() -> AnyIterator<Element> {
        var current = self.head
        return AnyIterator {
            let result = current?.element
            current = current?.next
            return result
        }
    }
}
