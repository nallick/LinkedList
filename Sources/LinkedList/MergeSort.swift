//
//  MergeSort.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//
//  Iterative merge sort derived from: https://www.geeksforgeeks.org/iterative-merge-sort-for-linked-list
//

extension LinkedList {

    /// Sort a single linked list, using an iterative merge sort.
    ///
    /// - Parameters:
    ///   - head: The head of the linked list.
    ///   - count: The number of nodes in the linked list.
    ///   - areInIncreasingOrder: A predicate that returns `true` if its first argument should be ordered before its second argument; otherwise, `false`.
    ///
    /// - Throws: Any error thrown by `areInIncreasingOrder`.
    ///
    /// - Returns: The new head of the sorted list.
    ///
    internal static func mergeSort(_ head: Node?, count: Int, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Node? {
        guard var sortedHead = head, count > 1 else { return head }

        var previousIterationEnd: Node?
        var gap = 1
        while gap < count {
            var iterationStart = sortedHead as Node?
            while var start1 = iterationStart {
                let startedWithHead = start1 === sortedHead

                var end1 = start1
                var counter = gap - 1
                while counter > 0, let nextEnd = end1.next {
                    end1 = nextEnd
                    counter -= 1
                }

                guard var start2 = end1.next else { break }
                var end2 = start2
                counter = gap - 1
                while counter > 0, let nextEnd = end2.next {
                    end2 = nextEnd
                    counter -= 1
                }

                iterationStart = end2.next
                try self.merge(&start1, &end1, &start2, &end2, areInIncreasingOrder)
                if startedWithHead {
                    sortedHead = start1
                } else {
                    previousIterationEnd?.next = start1
                }
                previousIterationEnd = end2
            }

            previousIterationEnd?.next = iterationStart
            gap *= 2
        }

        return sortedHead
    }

    private static func merge(_ start1: inout Node, _ end1: inout Node, _ start2: inout Node, _ end2: inout Node, _ areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows {
        if try areInIncreasingOrder(start2.element, start1.element) {
            swap(&start1, &start2)
            swap(&end1, &end2)
        }

        var node1 = start1
        var node2 = start2 as Node?
        let limit = end2.next
        while node1 !== end1, node2 !== limit {
            if try areInIncreasingOrder(node2!.element, node1.next!.element) {
                let next2 = node2!.next
                node2!.next = node1.next
                node1.next = node2
                node2 = next2
            }
            node1 = node1.next!
        }

        if node1 === end1 {
            node1.next = node2
        } else {
            end2 = end1
        }
    }
}
