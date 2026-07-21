import Foundation

extension Workday {
    static func mockData() -> [Workday] {
        [
            Workday(timesheetId: UUID())
        ]
    }

    static func mockWorkDay() -> Workday {
        Workday(timesheetId: UUID())
    }
}
