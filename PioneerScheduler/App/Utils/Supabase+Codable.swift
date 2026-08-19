import Foundation

/// Formatters for PostgREST timestamps.
///
/// Building a `DateFormatter` or `ISO8601DateFormatter` is expensive, and a
/// single timesheet carries ~20 date fields (two per timesheet plus three per
/// workday), so these are created once for the process rather than once per
/// decoded value. Both types are documented as safe for concurrent parsing as
/// long as they are not reconfigured, which they are not.
private enum SupabaseDateFormat {

    /// ISO8601 with milliseconds — what PostgREST returns most of the time, and
    /// what we encode with.
    static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    /// ISO8601 with whole seconds, for columns stored without sub-second precision.
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    /// Postgres `timestamptz` often serializes six fractional digits, which
    /// `ISO8601DateFormatter` rejects outright.
    static let microseconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        return formatter
    }()
}

extension JSONDecoder {

    /// Decoder for every Supabase read. Installed on the shared client in
    /// `Supabase.swift`, so `execute().value` uses it automatically — a plain
    /// `JSONDecoder()` will fail on real backend rows.
    static let supabase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let raw = try decoder.singleValueContainer().decode(String.self)
            // Studio and some clients render the separator as a space.
            let string = raw.contains(" ") ? raw.replacingOccurrences(of: " ", with: "T") : raw

            if let date = SupabaseDateFormat.iso8601WithFractionalSeconds.date(from: string) { return date }
            if let date = SupabaseDateFormat.iso8601.date(from: string) { return date }
            if let date = SupabaseDateFormat.microseconds.date(from: string) { return date }

            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Unrecognized date: \(raw)")
            )
        }
        return decoder
    }()
}

extension JSONEncoder {

    /// Encoder for every Supabase write. Installed on the shared client in
    /// `Supabase.swift`.
    static let supabase: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(SupabaseDateFormat.iso8601WithFractionalSeconds.string(from: date))
        }
        return encoder
    }()
}
