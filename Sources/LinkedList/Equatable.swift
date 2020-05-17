//
//  Equatable.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: Equatable where Element: Equatable {

    public static func == (lhs: LinkedList<Element>, rhs: LinkedList<Element>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return lhs.elementsEqual(rhs)
    }
}
