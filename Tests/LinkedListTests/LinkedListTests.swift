//
//  LinkedListTests.swift
//
//  Copyright © 2020 Purgatory Design. All rights reserved.
//

import BaseSwift
import LinkedList
import XCTest

final class LinkedListTests: XCTestCase {

    class CustomNode: LinkedList<CustomNode>.Node {
        let value: Int
        init(_ value: Int = 0) { self.value = value }
        override func instanceForListMutation() -> LinkedList<CustomNode>.Node { CustomNode(value) }
    }

    func testListIsInitializedEmpty() {
        let list = LinkedList<Int>()

        XCTAssertEqual(list.count, 0)
        XCTAssertTrue(list.isEmpty)
        XCTAssertFalse(list.isNotEmpty)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }

    func testAppendingToAnEmptyListAppendsAnItem() {
        var list = LinkedList<Int>()
        let expectedValue = 123

        list.append(expectedValue)

        validate(list)
        XCTAssertEqual(list.count, 1)
        XCTAssertFalse(list.isEmpty)
        XCTAssertTrue(list.isNotEmpty)
        XCTAssertEqual(list.first, expectedValue)
        XCTAssertEqual(list.last, expectedValue)
        XCTAssert(list.head === list.tail)
    }

    func testListsAreConvertedBackAndForthToEquivalentArrays() {
        let expectedValue = [123, 456, 789]
        let testList = LinkedList(expectedValue)

        let actualValue = Array(testList)

        validate(testList)
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testInsertingInAnEmptyListInsertsAnItem() {
        var list = LinkedList<Int>()
        let expectedValue = 123

        list.insert(expectedValue, before: nil)

        validate(list)
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first, expectedValue)
        XCTAssertEqual(list.last, expectedValue)
    }

    func testAppendingToNonEmptyListAppendsAnItem() {
        var list = LinkedList<Int>()
        let expectedValue = [123, 456]
        list.append(expectedValue[0])

        list.append(expectedValue[1])
        let actualValue = list.map { $0 }

        validate(list)
        XCTAssertEqual(list.count, expectedValue.count)
        XCTAssertEqual(list.first, expectedValue.first)
        XCTAssertEqual(list.last, expectedValue.last)
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testInsertingAtBeginningOfNonEmptyListInsertsAnItem() {
        var list = LinkedList<Int>()
        let expectedValue = [123, 456]
        list.append(expectedValue[1])

        list.insert(expectedValue[0], before: list.head)
        let actualValue = list.map { $0 }

        validate(list)
        XCTAssertEqual(list.count, expectedValue.count)
        XCTAssertEqual(list.first, expectedValue.first)
        XCTAssertEqual(list.last, expectedValue.last)
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testAppendingToNonTrivialListAppendsAnItem() {
        var list = LinkedList<Int>()
        let expectedValue = [123, 456, 789]
        list.append(expectedValue[0])
        list.append(expectedValue[1])

        list.append(expectedValue[2])
        let actualValue = list.map { $0 }

        validate(list)
        XCTAssertEqual(list.count, expectedValue.count)
        XCTAssertEqual(list.first, expectedValue.first)
        XCTAssertEqual(list.last, expectedValue.last)
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testInsertingInMiddleOfListInsertsAnItem() {
        var list = LinkedList<Int>()
        let expectedValue = [123, 456, 789]
        list.append(expectedValue[0])
        list.append(expectedValue[2])

        list.insert(expectedValue[1], before: list.tail)
        let actualValue = list.map { $0 }

        validate(list)
        XCTAssertEqual(list.count, expectedValue.count)
        XCTAssertEqual(list.first, expectedValue.first)
        XCTAssertEqual(list.last, expectedValue.last)
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testRemovingFirstItemFromListRemovesFirstItem() {
        let testValue = [123, 456, 789]
        var list = LinkedList(testValue)
        let expectedValue = Array(testValue.dropFirst())
        let expectedNode = list.head!

        let removedNode = list.remove(expectedNode)
        let actualValue = list.map { $0 }

        validate(list)
        XCTAssertEqual(list.count, expectedValue.count)
        XCTAssertEqual(list.first, expectedValue.first)
        XCTAssertEqual(list.last, expectedValue.last)
        XCTAssertEqual(actualValue, expectedValue)
        XCTAssertEqual(removedNode.element, expectedNode.element)
    }

    func testRemovingMiddleItemFromListRemovesMiddleItem() {
        let testValue = [123, 456, 789]
        var list = LinkedList(testValue)
        let expectedValue = [testValue.first!, testValue.last!]
        let expectedNode = list.head!.next!

        let removedNode = list.remove(expectedNode)
        let actualValue = list.map { $0 }

        validate(list)
        XCTAssertEqual(list.count, expectedValue.count)
        XCTAssertEqual(list.first, expectedValue.first)
        XCTAssertEqual(list.last, expectedValue.last)
        XCTAssertEqual(actualValue, expectedValue)
        XCTAssertEqual(removedNode.element, expectedNode.element)
    }

    func testRemovingLastItemFromListRemovesLastItem() {
        let testValue = [123, 456, 789]
        var list = LinkedList(testValue)
        let expectedValue = Array(testValue.dropLast())
        let expectedNode = list.tail!

        let removedNode = list.remove(expectedNode)
        let actualValue = list.map { $0 }

        validate(list)
        XCTAssertEqual(list.count, expectedValue.count)
        XCTAssertEqual(list.first, expectedValue.first)
        XCTAssertEqual(list.last, expectedValue.last)
        XCTAssertEqual(actualValue, expectedValue)
        XCTAssertEqual(removedNode.element, expectedNode.element)
    }

    func testRemovingAllFromListRemovesAllItems() {
        var list = LinkedList(123, 456, 789)

        list.removeAll()

        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }

    func testListsWithEqualValuesAreEqual() {
        let testValue = [123, 456, 789]
        let list1 = LinkedList(testValue)
        let list2 = LinkedList(testValue)

        validate(list1)
        validate(list2)
        XCTAssertEqual(list1, list2)
    }

    func testReversedListsAreReversed() {
        let testValue = [123, 456, 789]
        var list = LinkedList(testValue)

        list.reverse()

        validate(list)
        XCTAssertEqual(Array(list), testValue.reversed())
    }

    func testNodeAtIndex() {
        let list = LinkedList(123, 456, 789)

        let firstNode = list.node(at: list.startIndex)
        let middleNode = list.node(at: list.index(after: list.startIndex))
        let lastNode = list.node(at: list.lastIndex)

        XCTAssertEqual(firstNode, list.head)
        XCTAssertEqual(middleNode, list.head?.next)
        XCTAssertEqual(lastNode, list.tail)
    }

    func testIndexForNode() {
        let list = LinkedList(123, 456, 789)

        let firstIndex = list.index(for: list.head!)
        let middleIndex = list.index(for: list.head!.next!)
        let lastIndex = list.index(for: list.tail!)

        XCTAssertEqual(firstIndex, list.startIndex)
        XCTAssertEqual(middleIndex, list.index(after: list.startIndex))
        XCTAssertEqual(lastIndex, list.lastIndex)
    }

    func testDropFirst() {
        let testValue = [123, 456, 789]
        let fullList = LinkedList(testValue)

        let slicedList = fullList.dropFirst()

        validate(slicedList)
        XCTAssertEqual(LinkedList(slicedList), LinkedList(testValue.dropFirst()))
    }

    func testDropLast() {
        let testValue = [123, 456, 789]
        let fullList = LinkedList(testValue)

        let slicedList = fullList.dropLast()

        validate(slicedList)
        XCTAssertEqual(LinkedList(slicedList), LinkedList(testValue.dropLast()))
    }

    func testDistanceFromTo() {
        let list: LinkedList = [123, 456, 789]

        let actualDistance = list.distance(from: list.startIndex, to: list.endIndex)

        validate(list)
        XCTAssertEqual(actualDistance, list.count)
    }

    func testReplaceSubrangeWith() {
        var list = LinkedList(10, 20, 30, 40, 50)
        let startOfRange = list.index(list.startIndex, offsetBy: 1)
        let endOfRange = list.index(list.startIndex, offsetBy: 3)

        list.replaceSubrange(startOfRange...endOfRange, with: repeatElement(1, count: 5))

        validate(list)
        XCTAssertEqual(Array(list), [10, 1, 1, 1, 1, 1, 50])
    }

    func testReplaceAtStart() {
        var list = LinkedList(10, 20, 30)

        list.replaceSubrange(list.startIndex...list.startIndex, with: [1, 2])

        validate(list)
        XCTAssertEqual(Array(list), [1, 2, 20, 30])
    }

    func testReplaceAtEnd() {
        var list = LinkedList(10, 20, 30)

        list.replaceSubrange(list.lastIndex ..< list.endIndex, with: [1, 2])

        validate(list)
        XCTAssertEqual(Array(list), [10, 20, 1, 2])
    }

    func testAppendContentsOfToEmpty() {
        var list = LinkedList<Int>()

        list.append(contentsOf: 1...3)

        validate(list)
        XCTAssertEqual(Array(list), Array(1...3))
    }

    func testAppendContentsOfToExisting() {
        var list = LinkedList(1, 2, 3)

        list.append(contentsOf: 4...6)

        validate(list)
        XCTAssertEqual(Array(list), Array(1...6))
    }

    func testConcatinate() {
        let list1 = LinkedList(1, 2, 3)

        let list2 = list1 + (4...6)

        validate(list2)
        XCTAssertEqual(list2, LinkedList(1...6))
    }

    func testInsertContentsOfToEmpty() {
        var list = LinkedList<Int>()

        list.insert(contentsOf: 1...3, at: list.startIndex)

        validate(list)
        XCTAssertEqual(Array(list), Array(1...3))
    }

    func testInsertContentsOfToExisting() {
        var list = LinkedList(4, 5, 6)

        list.insert(contentsOf: 1...3, at: list.startIndex)

        validate(list)
        XCTAssertEqual(Array(list), Array(1...6))
    }

    func testRemoveAtStart() {
        var list = LinkedList(1, 2, 3)

        list.remove(at: list.startIndex)

        validate(list)
        XCTAssertEqual(Array(list), [2, 3])
    }

    func testRemoveAtEnd() {
        var list = LinkedList(1, 2, 3)

        list.remove(at: list.lastIndex)

        validate(list)
        XCTAssertEqual(Array(list), [1, 2])
    }

    func testSortInPlace() {
        var list1 = LinkedList(40, 20, 60, 10, 50, 30)
        var list2 = list1

        list1.sort()
        list2.sort(by: >)

        validate(list1)
        validate(list2)
        XCTAssertEqual(Array(list1), [10, 20, 30, 40, 50, 60])
        XCTAssertEqual(Array(list2), [60, 50, 40, 30, 20, 10])
    }

    func testLargeSortInPlace() {
        let loopMultiplier = Int(CommandLine.parameters?["--TestLoopMultiplier"]?.first ?? "") ?? 1
        let loopCount = 2000*loopMultiplier
        let range = 5000*loopMultiplier

        var list = LinkedList<Int>()
        for _ in 1...loopCount { list.append(Int.random(in: 0 ..< range)) }

        list.sort()

        var previous = -1
        for value in list {
            XCTAssertGreaterThanOrEqual(value, previous)
            previous = value
        }
    }

    func testSorted() {
        let unsortedList = LinkedList(2, 1, 3)

        let list1 = unsortedList.sorted()
        let list2 = unsortedList.sorted(by: >)

        XCTAssertEqual(Array(list1), [1, 2, 3])
        XCTAssertEqual(Array(list2), [3, 2, 1])
    }

    func testMutableSubscript() {
        var list = LinkedList(0, 2, 3)

        list[list.startIndex] = 1

        validate(list)
        XCTAssertEqual(Array(list), [1, 2, 3])
    }

    func testSwapAt() {
        var list1 = LinkedList(1, 2, 3)
        var list2 = list1

        list1.swapAt(list1.startIndex, list1.index(after: list1.startIndex))
        list2.swapAt(list2.startIndex, list2.lastIndex)

        validate(list1)
        validate(list2)
        XCTAssertEqual(Array(list1), [2, 1, 3])
        XCTAssertEqual(Array(list2), [3, 2, 1])
    }

    func testMoveFromTo() {
        var list1 = LinkedList(1, 2, 3, 4, 5)
        var list2 = list1
        var list3 = list1

        list1.move(from: [list1[index: 0], list1[index: 1]], to: list1[reverseIndex: 1])
        list2.move(from: [list2[index: 2], list2[index: 3]], to: list2[index: 0])
        list3.move(from: [list3[index: 0], list3[index: 2], list3[index: 4]], to: list3[index: 0])

        validate(list1)
        validate(list2)
        validate(list3)
        XCTAssertEqual(Array(list1), [3, 1, 2, 4, 5])
        XCTAssertEqual(Array(list2), [3, 4, 1, 2, 5])
        XCTAssertEqual(Array(list3), [1, 3, 5, 2, 4])
    }

    func testPartition() {
        var list1 = LinkedList(30, 40, 20, 30, 30, 60, 10)
        var list2 = list1
        let partitionValue1 = 30
        let partitionValue2 = 40

        let secondPartition1 = list1.partition { $0 > partitionValue1 }
        let secondPartition2 = list2.partition { $0 > partitionValue2 }

        validate(list1)
        validate(list2)
        let ultimateIndex = list1.lastIndex
        let penultimateIndex = list1.index(before: ultimateIndex)
        XCTAssertEqual(secondPartition1, penultimateIndex)
        XCTAssertEqual(secondPartition2, list2.lastIndex)
        XCTAssertGreaterThan(list1[penultimateIndex], partitionValue1)
        XCTAssertGreaterThan(list1[ultimateIndex], partitionValue1)
    }

    func testCustomNodeIsAddedToList() {
        let expectedNode = CustomNode()
        var list = LinkedList<CustomNode>()

        list.append(expectedNode)

        validate(list)
        XCTAssert(list.head === expectedNode)
        XCTAssert(list.tail === expectedNode)
    }

    func testCustomNodeIsRemovedFromList() {
        let testNode = CustomNode()
        var list = LinkedList(testNode)

        list.remove(testNode)

        validate(list)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(testNode.previous)
        XCTAssertNil(testNode.next)
    }

    func testCustomNodeIsListValue() {
        let expectedValue = CustomNode()
        let list = LinkedList(expectedValue)

        let actualValue = list.first

        validate(list)
        XCTAssert(actualValue === expectedValue)
    }

    func testCustomNodeMutableSubscript() {
        let initialValue = CustomNode()
        let expectedValue = CustomNode()
        var list = LinkedList(initialValue)

        list[list.startIndex] = expectedValue
        let actualValue = list.first

        validate(list)
        XCTAssert(actualValue === expectedValue)
    }

    func testCustomNodeSwapAt() {
        var list1 = LinkedList(CustomNode(1), CustomNode(2), CustomNode(3))
        var list2 = list1

        list1.swapAt(list1.startIndex, list1.lastIndex)
        list2.swapAt(list2.startIndex, list2.index(after: list2.startIndex))

        validate(list1)
        validate(list2)
        XCTAssertEqual(list1.map { $0.value }, [3, 2, 1])
        XCTAssertEqual(list2.map { $0.value }, [2, 1, 3])
    }

//  This fails because the default partition implementation doesn't reset indices after swapAt().
//
//    func testCustomNodePartition() {
//        var list = LinkedList(CustomNode(1), CustomNode(2), CustomNode(3), CustomNode(4))
//        let partitionValue = 3
//
//        let secondPartition = list.partition { $0.value > partitionValue }
//
//        let values = list.map { $0.value }
//        print(values)
//
//        let ultimateIndex = list.index(before: list.endIndex)
//        let penultimateIndex = list.index(before: ultimateIndex)
//        XCTAssertEqual(secondPartition, penultimateIndex)
//        XCTAssertGreaterThan(list[penultimateIndex].value, partitionValue)
//        XCTAssertGreaterThan(list[ultimateIndex].value, partitionValue)
//    }

    func testNodeAtOffset() {
        let nodes = (1...7).map { _ in CustomNode() }
        let list = LinkedList(nodes)

        validate(list)
        XCTAssertNil(list.node(offset: -1))
        XCTAssertNil(list.node(offset: nodes.count))
        for (index, node) in nodes.enumerated() {
            XCTAssertEqual(list.node(offset: index), node, "node at offset failed at: \(index)")
        }
    }

    func testDecoding() throws {
        let encodedData = "[1,2,3]".data(using: .utf8)!
        let decoder = JSONDecoder()

        let decodedList = try decoder.decode(LinkedList<Int>.self, from: encodedData)

        validate(decodedList)
        XCTAssertEqual(decodedList, LinkedList(1, 2, 3))
    }

    func testEncoding() throws {
        let list = LinkedList(1, 2, 3)
        let encoder = JSONEncoder()

        let encodedList = try encoder.encode(list)

        XCTAssertEqual(String(data: encodedList, encoding: .utf8), "[1,2,3]")
    }

    func testHashValue() {
        let list1 = LinkedList(1, 2, 3)
        let list2 = LinkedList(1, 2, 3)
        let list3 = LinkedList(4, 5, 6)

        let hashValue1 = list1.hashValue
        let hashValue2 = list2.hashValue
        let hashValue3 = list3.hashValue

        XCTAssertEqual(hashValue1, hashValue2)
        XCTAssertNotEqual(hashValue1, hashValue3)
    }

    func testDescription() {
        let list = LinkedList(1, 2, 3)
        XCTAssertEqual(list.description, "[1, 2, 3]")
    }

    func testInitializeFromSequence() {
        let expectedValue = [1, 2, 3]
        let sequence = AnySequence(expectedValue)

        let list = LinkedList<Int>(sequence)

        validate(list)
        XCTAssertEqual(Array(list), expectedValue)
    }

    func testCopiedListIsIndependentFromOriginal() {
        let testValue = [123, 456, 789]
        var list1 = LinkedList(testValue)
        let list2 = list1

        list1.remove(list1.head!)

        validate(list1)
        validate(list2)
        XCTAssertEqual(Array(list1), Array(testValue.dropFirst()))
        XCTAssertEqual(Array(list2), Array(testValue))
    }

    func testListsInThreads() {
        // with ThreadSanitizer enabled this will frequently fail if copy-on-write isn't atomic

        let q1 = DispatchQueue(label: "queue1")
        let q2 = DispatchQueue(label: "queue2")
        let q3 = DispatchQueue(label: "queue3")
        let q4 = DispatchQueue(label: "queue4")
        let q5 = DispatchQueue(label: "queue5")

        var list = LinkedList<Int>()

        let iterations = 100

        var copy1 = list
        q1.async {
            for i in 1 ... iterations {
                copy1.append(1000 + i)
            }
        }

        var copy2 = list
        q2.async {
            for i in 1 ... iterations {
                copy2.append(2000 + i)
            }
        }

        var copy3 = list
        q3.async {
            for i in 1 ... iterations {
                copy3.append(3000 + i)
            }
        }

        var copy4 = list
        q4.async {
            for i in 1 ... iterations {
                copy4.append(4000 + i)
            }
        }

        var copy5 = list
        q5.async {
            for i in 1 ... iterations {
                copy5.append(5000 + i)
            }
        }

        for i in 1 ... iterations {
            list.append(i)
        }

        q1.sync {}
        q2.sync {}
        q3.sync {}

        let array = Array(list)
        XCTAssertEqual(array.prefix(3), [1, 2, 3])
        XCTAssertEqual(copy1.map { $0 - 1000 }, array)
        XCTAssertEqual(copy2.map { $0 - 2000 }, array)
        XCTAssertEqual(copy3.map { $0 - 3000 }, array)
    }
}

extension LinkedListTests {

    func validate<T>(_ list: LinkedList<T>) {
        var count = 0
        var previous: LinkedList<T>.Node?
        var nextNode = list.head
        while let node = nextNode {
            XCTAssert(node.previous === previous)
            count += 1
            nextNode = node.next
            previous = node
        }

        XCTAssertEqual(count, list.count)
        XCTAssert(previous === list.tail)
    }

    func validate<T>(_ slice: Slice<LinkedList<T>>) {
        validate(LinkedList(slice))
    }

    static var allTests = [
        ("testAppendContentsOfToEmpty", testAppendContentsOfToEmpty),
        ("testAppendContentsOfToExisting", testAppendContentsOfToExisting),
        ("testAppendingToAnEmptyListAppendsAnItem", testAppendingToAnEmptyListAppendsAnItem),
        ("testAppendingToNonEmptyListAppendsAnItem", testAppendingToNonEmptyListAppendsAnItem),
        ("testAppendingToNonTrivialListAppendsAnItem", testAppendingToNonTrivialListAppendsAnItem),
        ("testConcatinate", testConcatinate),
        ("testCopiedListIsIndependentFromOriginal", testCopiedListIsIndependentFromOriginal),
        ("testCustomNodeIsAddedToList", testCustomNodeIsAddedToList),
        ("testCustomNodeIsListValue", testCustomNodeIsListValue),
        ("testCustomNodeIsRemovedFromList", testCustomNodeIsRemovedFromList),
        ("testCustomNodeMutableSubscript", testCustomNodeMutableSubscript),
        ("testCustomNodeSwapAt", testCustomNodeSwapAt),
        ("testDecoding", testDecoding),
        ("testDescription", testDescription),
        ("testDistanceFromTo", testDistanceFromTo),
        ("testDropFirst", testDropFirst),
        ("testDropLast", testDropLast),
        ("testEncoding", testEncoding),
        ("testHashValue", testHashValue),
        ("testIndexForNode", testIndexForNode),
        ("testInitializeFromSequence", testInitializeFromSequence),
        ("testInsertContentsOfToEmpty", testInsertContentsOfToEmpty),
        ("testInsertContentsOfToExisting", testInsertContentsOfToExisting),
        ("testInsertingAtBeginningOfNonEmptyListInsertsAnItem", testInsertingAtBeginningOfNonEmptyListInsertsAnItem),
        ("testInsertingInAnEmptyListInsertsAnItem", testInsertingInAnEmptyListInsertsAnItem),
        ("testInsertingInMiddleOfListInsertsAnItem", testInsertingInMiddleOfListInsertsAnItem),
        ("testLargeSortInPlace", testLargeSortInPlace),
        ("testListIsInitializedEmpty", testListIsInitializedEmpty),
        ("testListsAreConvertedBackAndForthToEquivalentArrays", testListsAreConvertedBackAndForthToEquivalentArrays),
        ("testListsInThreads", testListsInThreads),
        ("testListsWithEqualValuesAreEqual", testListsWithEqualValuesAreEqual),
        ("testMoveFromTo", testMoveFromTo),
        ("testMutableSubscript", testMutableSubscript),
        ("testNodeAtIndex", testNodeAtIndex),
        ("testNodeAtOffset", testNodeAtOffset),
        ("testPartition", testPartition),
        ("testRemoveAtEnd", testRemoveAtEnd),
        ("testRemoveAtStart", testRemoveAtStart),
        ("testRemovingAllFromListRemovesAllItems", testRemovingAllFromListRemovesAllItems),
        ("testRemovingFirstItemFromListRemovesFirstItem", testRemovingFirstItemFromListRemovesFirstItem),
        ("testRemovingLastItemFromListRemovesLastItem", testRemovingLastItemFromListRemovesLastItem),
        ("testRemovingMiddleItemFromListRemovesMiddleItem", testRemovingMiddleItemFromListRemovesMiddleItem),
        ("testReplaceAtEnd", testReplaceAtEnd),
        ("testReplaceAtStart", testReplaceAtStart),
        ("testReplaceSubrangeWith", testReplaceSubrangeWith),
        ("testReversedListsAreReversed", testReversedListsAreReversed),
        ("testSortInPlace", testSortInPlace),
        ("testSorted", testSorted),
        ("testSwapAt", testSwapAt),
    ]
}
