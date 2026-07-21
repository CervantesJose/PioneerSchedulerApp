import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: Constants.supabaseProjectURL)!,
    supabaseKey: Constants.supabaseAPIKey
)
