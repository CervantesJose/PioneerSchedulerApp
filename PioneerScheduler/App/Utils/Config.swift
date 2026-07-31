import Foundation

/// Typed access to configuration injected at build time.
///
/// If a value is missing the app traps at launch with a message pointing here,
/// rather than failing silently against an empty URL/key.
enum Config {
    static let supabaseURL = url(for: "SUPABASE_URL")
    static let supabaseAnonKey = string(for: "SUPABASE_ANON_KEY")

    private static func string(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              value.isEmpty == false else {
            fatalError(
                """
                Missing configuration value for "\(key)". \
                Copy Config/Secrets.local.example.xcconfig to Config/Secrets.local.xcconfig, \
                fill in your Supabase credentials, then clean-build (⇧⌘K).
                """
            )
        }
        return value
    }

    private static func url(for key: String) -> URL {
        let value = string(for: key)
        guard let url = URL(string: value) else {
            fatalError(#"Configuration value for "\#(key)" is not a valid URL: \#(value)"#)
        }
        return url
    }
}
