//
//  CustomStringConvertible.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: CustomStringConvertible {

    @inlinable public var description: String { Array(self).description }
}
