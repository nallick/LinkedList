//
//  Hashable.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: Hashable where Element: Hashable {

    public func hash(into hasher: inout Hasher) {
        for element in self { hasher.combine(element) }
    }
}
