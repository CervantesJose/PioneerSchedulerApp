import Foundation

/// A single task line within a workday.
///
/// Carries a stable `id` so SwiftUI can track each row across edits and
/// reorders. The `Codable` conformance intentionally encodes/decodes as a
/// bare `String`, so `[TaskItem]` serializes to `["a", "b"]` — matching the
/// Supabase `text[]` column. The `id` is generated fresh on decode; it is an
/// in-memory identity only and is never persisted.
struct TaskItem: Identifiable, Hashable, Codable {
    let id: UUID
    var text: String

    init(id: UUID = UUID(), text: String = "") {
        self.id = id
        self.text = text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.id = UUID()
        self.text = try container.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(text)
    }
}

struct Workday: Codable, Identifiable, Hashable {

    enum CodingKeys: String, CodingKey {
        case id, date, tasks
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case timesheetId = "timesheet_id"
    }

    var id: UUID
    var timesheetId: UUID
    var date: Date
    var tasks: [TaskItem]
    var timeStart: Date
    var timeEnd: Date

    var duration: TimeInterval { max(0, timeEnd.timeIntervalSince(timeStart)) }

    init(
        id: UUID = UUID(),
        timesheetId: UUID,
        date: Date = .now,
        tasks: [TaskItem] = [],
        timeStart: Date = (Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: .now) ?? .now),
        timeEnd: Date = (Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: .now) ?? .now)
    ) {
        self.id = id
        self.timesheetId = timesheetId
        self.date = date
        self.tasks = tasks
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
}

extension Workday {
    mutating func addTask() {
        tasks.append(TaskItem())
    }

    mutating func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
}
