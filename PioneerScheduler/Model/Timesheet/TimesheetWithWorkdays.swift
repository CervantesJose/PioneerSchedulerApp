import Foundation

struct TimesheetWithWorkdays: Codable, Identifiable, Hashable {

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case workday
    }

    var id: UUID
    var userId: UUID
    var startDate: Date
    var endDate: Date
    var workday: [Workday]
}

extension TimesheetWithWorkdays {

    /// Assembles the read model from its two halves.
    ///
    /// Lets a caller that already holds both the timesheet row and its workdays
    /// build the hydrated shape locally instead of spending a round trip on the
    /// nested `*, workday(*)` select.
    init(row: TimesheetRow, workday: [Workday]) {
        self.init(
            id: row.id,
            userId: row.userId,
            startDate: row.startDate,
            endDate: row.endDate,
            workday: workday
        )
    }

    /// The timesheet's own columns, without its workdays.
    var row: TimesheetRow {
        TimesheetRow(id: id, userId: userId, startDate: startDate, endDate: endDate)
    }
}
