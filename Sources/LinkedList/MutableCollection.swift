//
//  MutableCollection.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: MutableCollection {

    public subscript(index: Index) -> Element {
        get {
            self.node(at: index).element
        } set {
            let node = self.node(at: index)
            let replaceNode = self.ensureUniqueCopyForMutation(preserving: node)
            replaceNode?.updateElement(newValue, in: self.storage)
        }
    }

    public mutating func reverse() {
        self.ensureUniqueCopyForMutation()
        self.storage.reverse()
    }

    public mutating func sort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        guard count > 1 else { return }
        self.ensureUniqueCopyForMutation()
        let sortedHead = try LinkedList.mergeSort(self.head, count: self.count, by: areInIncreasingOrder)
        self.storage.singleToDoubleLinkedList(sortedHead)
    }

    public mutating func swapAt(_ index1: LinkedList.Index, _ index2: LinkedList.Index) {
        guard index1 != index2 else { return }
        var node1 = self.node(at: index1)
        var node2 = self.node(at: index2)
        if let adjustedNode = self.ensureUniqueCopyForMutation(preserving: node1), adjustedNode !== node1 {
            node1 = adjustedNode
            node2 = self.node(offset: index2.offset)!
        }

        if node1.element is Node {
            if index1.offset > index2.offset { swap(&node1, &node2) }
            let next1 = node1.next
            let next2 = node2.next
            self.storage.remove(node1)
            self.storage.remove(node2)
            self.storage.insert(node: node1, before: next2)
            self.storage.insert(node: node2, before: (next1 === node2) ? node1 : next1)
        } else {
            let element1 = node1.element
            node1.updateElement(node2.element, in: self.storage)
            node2.updateElement(element1, in: self.storage)
        }
    }

    /// Move one or more nodes in the receiver to a new location.
    ///
    /// - Parameters:
    ///   - source: The nodes to move.
    ///   - destination: The index of the node to place the moved modes before.
    ///
    /// - Note: This is similar to MutableCollection.move(fromOffsets:toOffset:) defined by SwiftUI, but uses Index rather than IndexSet.
    ///
    public mutating func move(from source: [Index], to destination: Index) {
        guard source.count > 0, source.count != 1 || source[0] != destination else { return }
        var sourceNodes = source.map { self.node(at: $0) }
        var destinationNode = destination.node
        var destinationOffset = destination.offset
        while let node = destinationNode, sourceNodes.contains(node) {
            destinationNode = node.next
            destinationOffset += 1
        }

        if let adjustedNode = self.ensureUniqueCopyForMutation(preserving: sourceNodes[0]), adjustedNode !== sourceNodes[0] {
            sourceNodes[0] = adjustedNode
            for index in stride(from: 1, through: sourceNodes.count - 1, by: 1) {
                sourceNodes[index] = self.node(offset: source[index].offset)!
            }
            if let _ = destinationNode {
                destinationNode = self.node(offset: destinationOffset)
            }
        }

        for node in sourceNodes { self.storage.remove(node) }
        for node in sourceNodes { self.storage.insert(node: node, before: destinationNode) }
    }
}

extension LinkedList where LinkedList.Element: Comparable {

    @inlinable public mutating func sort() {
        self.sort(by: <)
    }
}
