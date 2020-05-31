//
//  CustomReflectable.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: CustomReflectable {

    @inlinable public var customMirror: Mirror {
        Mirror(self, unlabeledChildren: self, displayStyle: .collection)
    }
}
