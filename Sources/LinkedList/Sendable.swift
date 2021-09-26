//
//  Sendable.swift
//
//  Copyright © 2021 Purgatory Design. Licensed under the MIT License.
//

import Foundation

@available(swift 5.5)
@available(iOS 15.0, macOS 12.0, *)
extension LinkedList: @unchecked Sendable where Element: Sendable {}
