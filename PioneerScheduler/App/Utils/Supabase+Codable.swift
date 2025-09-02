//
//  Supabase+Codable.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 8/16/25.
//

import Foundation

extension JSONDecoder {
    static var supabase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { d in
            let raw = try d.singleValueContainer().decode(String.self)
            let string = raw.replacingOccurrences(of: " ", with: "T") // UI sometimes shows a space

            // 1) ISO8601 with fractional seconds
            let isoFrac = ISO8601DateFormatter()
            isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let dateString = isoFrac.date(from: string) { return dateString }

            // 2) ISO8601 without fractional seconds
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime]
            if let dateTime = iso.date(from: string) { return dateTime }

            // 3) Handle microseconds explicitly, just in case (PostgREST often returns 6 digits)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
            if let dateTime = dateFormatter.date(from: string) { return dateTime }

            throw DecodingError.dataCorrupted(
                .init(codingPath: d.codingPath, debugDescription: "Unrecognized date: \(raw)")
            )
        }
        return decoder
    }
}

extension JSONEncoder {
    static var supabase: JSONEncoder {
        let encoder = JSONEncoder()
        let format = ISO8601DateFormatter()

        format.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        encoder.dateEncodingStrategy = .custom { date, e in
            var custom = e.singleValueContainer()
            try custom.encode(format.string(from: date))
        }
        return encoder
    }
}
