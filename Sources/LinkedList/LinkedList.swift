//
//  LinkedList.swift
//
//  A double linked list value type, implementing all Collection protocols apart from RandomAccessCollection.
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

public struct LinkedList<Element> {

    public var head: Node? { self.storage.head }
    public var tail: Node? { self.storage.tail }

    public internal(set) var count = 0
    @inlinable public var isEmpty: Bool { self.count == 0 }
    @inlinable public var isNotEmpty: Bool { self.count != 0 }

    public typealias ElementType = Element

    internal var storage = LinkedListStorage()

    /// Initialize a linked list with a variadic list of elements.
    ///
    /// - Parameter elements: The elements for the new list.
    ///
    @inlinable public init(_ elements: Element...) {
        self.init(elements)
    }

    /// Initialize a linked list with an array of elements.
    ///
    /// - Parameter array: The elements for the new list.
    ///
    public init(_ array: Array<Element>) {
        for element in array { self.storage.append(element) }
        self.count = array.count
    }

    /// Initialize a linked list with a collection of elements.
    ///
    /// - Parameter collection: The elements for the new list.
    ///
    public init<C>(_ collection: C) where C: Collection, C.Element == Element {
        for element in collection { self.storage.append(element) }
        self.count = collection.count
    }

    /// Initialize a linked list with a sequence of elements.
    ///
    /// - Parameter sequence: The elements for the new list.
    ///
    public init<S>(_ sequence: S) where S: Sequence, S.Element == Element {
        for element in sequence {
            self.storage.append(element)
            self.count += 1
        }
    }

    /// Append an element to the receiver.
    ///
    /// - Parameter element: The element to append.
    ///
    /// - Returns: The new node containing the element.
    ///
    @inlinable @discardableResult
    public mutating func append(_ element: Element) -> Node {
        self.insert(element, before: nil)
    }

    /// Insert an element in the receiver.
    ///
    /// - Parameters:
    ///   - element: The element to insert.
    ///   - next: The node to insert the new element before in the list.
    ///
    /// - Returns: The new node containing the element.
    ///
    @discardableResult
    public mutating func insert(_ element: Element, before next: Node?) -> Node {
        let adjustedNext = self.ensureUniqueCopyForMutation(preserving: next)
        self.count += 1
        return self.storage.insert(element: element, before: adjustedNext)
    }

    /// Get the node at the specified index in the receiver, or generate a fatal "index out of range" error.
    ///
    /// - Parameter index: The index of the node to get.
    ///
    /// - Returns: The node at the specified index.
    ///
    public func node(at index: Index) -> Node {
        guard let node = self.optionalNode(at: index) else { fatalError("Index out of range") }
        return node
    }

    /// Get the node at the specified offset in the receiver (if it exists).
    ///.
    /// - Parameter offset: The integer offset of the node in the receiver.
    ///
    /// - Returns: The node at the specified offset, or `nil`.
    ///
    public func node(offset: Int) -> Node? {
        if offset <= self.count/2 {
            guard offset >= 0 else { return nil }
            var result = self.storage.head
            for _ in stride(from: 1, through: offset, by: 1) { result = result?.next }   // may loop zero times
            return result
        }

        guard offset < self.count else { return nil }
        var result = self.storage.tail
        for _ in stride(from: self.count - 2, through: offset, by: -1) { result = result?.previous }
        return result
    }

    /// Remove one or more nodes from the receiver.
    ///
    /// - Parameters:
    ///   - node: The first node in the receiver to remove.
    ///   - count: The number of nodes to remove.
    ///
    /// - Returns: The first node removed.
    ///
    @discardableResult
    public mutating func remove(_ node: Node, count: Int = 1) -> Node {
        guard count > 0,
            let removeNode = self.ensureUniqueCopyForMutation(preserving: node)
            else { return node }
        self.storage.remove(removeNode, count: count)
        self.count -= count
        return removeNode
    }

    /// Remove all nodes from the receiver.
    ///
    public mutating func removeAll() {
        guard self.count > 0 else { return }
        self.storage = LinkedListStorage()
        self.count = 0
    }

    /// Get the node at the specified index in the receiver, if it exists.
    ///
    /// - Parameter index: The index of the node to get.
    ///
    /// - Returns: The node at the specified index, or `nil`.
    ///
    internal func optionalNode(at index: Index) -> Node? {
        (index.parent === self.storage) ? index.node : self.node(offset: index.offset)   // copy-on-write may have changed the storage under the index
    }

    /// Ensure the receiver contains a unique copy of the internal list storage, by copying that storage if multiple copies exist.
    ///
    /// - Parameter node: A node to preserve across a copy.
    ///
    /// - Returns: Any preserved node.
    ///
    /// - Note: This method is thread safe.
    ///
    @discardableResult
    internal mutating func ensureUniqueCopyForMutation(preserving node: Node? = nil) -> Node? {
        self.storage.copyOnWriteMutex.sync {
            if isKnownUniquelyReferenced(&self.storage) { return node }

            let originalNodes = self.storage.allNodes
            self.storage = LinkedListStorage(originalNodes)
            guard let preservedOffset = node.flatMap({ originalNodes.firstIndex(of: $0) }) else { return nil }
            return self.node(offset: preservedOffset)
        }
    }
}
