import Foundation

/// Table and column identifiers used when querying Supabase.
enum SBConstants {
    static let workdayTable = "workday"
    static let timesheetsTable = "timesheets"
    static let workdayColumn = "*, workday(*)"
    static let idStringColumn = "id"
    static let uidColumn = "user_id"
    static let endDateColumn = "end_date"
    static let all = "*"
}
