//
//  Codable.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

extension LinkedList: Decodable where Element: Decodable {

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.count = container.count ?? 0
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.storage.append(element)
        }
    }
}

extension LinkedList: Encodable where Element: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self { try container.encode(element) }
    }
}
