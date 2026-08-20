import Foundation
import Supabase

/// The shared Supabase client.
///
/// The custom encoder/decoder are installed here rather than at each call site,
/// so `insert`/`upsert` payloads and `execute().value` responses both go through
/// the tolerant PostgREST date handling in `Supabase+Codable.swift` without any
/// view model having to remember to opt in.
///
/// Only the **anon** key belongs here. Row-level security — defined by the
/// "RLS tables" saved query in the Supabase dashboard, not by anything in this
/// repo — is what actually scopes rows to the signed-in user; the
/// `.eq("user_id", ...)` filters in the view models are conveniences, not a
/// security boundary, because this key ships inside the app bundle.
let supabase = SupabaseClient(
    supabaseURL: Config.supabaseURL,
    supabaseKey: Config.supabaseAnonKey,
    options: SupabaseClientOptions(
        db: SupabaseClientOptions.DatabaseOptions(
            encoder: .supabase,
            decoder: .supabase
        )
    )
)
