//
//  CustomStringConvertible.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: CustomStringConvertible, CustomDebugStringConvertible {

    @inlinable public var description: String { Array(self).description }

    @inlinable public var debugDescription: String { self.description }
}
