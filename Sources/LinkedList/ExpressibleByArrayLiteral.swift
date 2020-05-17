//
//  ExpressibleByArrayLiteral.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: ExpressibleByArrayLiteral {

    public typealias ArrayLiteralElement = Element

    @inlinable public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}
