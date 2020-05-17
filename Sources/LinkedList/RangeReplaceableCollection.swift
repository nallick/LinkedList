//
//  RangeReplaceableCollection.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: RangeReplaceableCollection {

    @inlinable public init() {}

    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression, LinkedList.Element == C.Element, LinkedList.Index == R.Bound {
        let range = subrange.relative(to: self)
        let addCount = newElements.count
        let removeCount = range.upperBound.offset - range.lowerBound.offset
        guard addCount > 0 || removeCount > 0 else { return }

        let firstRemoveNode = self.ensureUniqueCopyForMutation(preserving: range.lowerBound.node)
        let insertAfterNode = firstRemoveNode.map { $0.previous } ?? self.tail

        self.storage.remove(firstRemoveNode, count: removeCount)

        let insertBeforeNode = insertAfterNode.map { $0.next } ?? self.head
        for element in newElements {
            _ = self.storage.insert(element: element, before: insertBeforeNode)
        }

        self.count += addCount - removeCount
    }
}
