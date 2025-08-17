//
//  Supabase+Codable.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 8/16/25.
//

import Foundation

extension JSONDecoder {
    static var supabase: JSONDecoder {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { d in
            let string = try d.singleValueContainer().decode(String.self)

            let format = ISO8601DateFormatter()
            format.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let formattedDate = format.date(from: string) { return formattedDate }

            throw DecodingError
                .dataCorrupted(.init(codingPath: d.codingPath, debugDescription: "Unrecognized date: \(string)"))
        }

        return decoder
    }
}

extension JSONEncoder {
    static var supabase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
