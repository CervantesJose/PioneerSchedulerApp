//
//  Supabase.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/23/25.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: Constants.supabaseProjectURL)!,
    supabaseKey: Constants.supabaseAPIKey
)
