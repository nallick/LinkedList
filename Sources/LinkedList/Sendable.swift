//
//  Sendable.swift
//
//  Copyright © 2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@available(swift 5.5)
@available(iOS 13, macOS 10.15, watchOS 8, tvOS 13, *)
extension LinkedList: @unchecked Sendable where Element: Sendable {}
