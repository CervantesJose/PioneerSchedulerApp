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
            let s = raw.replacingOccurrences(of: " ", with: "T") // UI sometimes shows a space

            // 1) ISO8601 with fractional seconds
            let isoFrac = ISO8601DateFormatter()
            isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let dt = isoFrac.date(from: s) { return dt }

            // 2) ISO8601 without fractional seconds
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime]
            if let dt = iso.date(from: s) { return dt }

            // 3) Handle microseconds explicitly, just in case (PostgREST often returns 6 digits)
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(secondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
            if let dt = df.date(from: s) { return dt }

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
            var c = e.singleValueContainer()
            try c.encode(format.string(from: date))
        }
        return encoder
    }
}
