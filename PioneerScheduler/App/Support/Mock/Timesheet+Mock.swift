import Foundation

extension TimesheetWithWorkdays {
    static func mockData() -> [TimesheetWithWorkdays] {
        [
            TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workday: Workday.mockData()
            ),
            TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workday: []
            ),
            TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workday: []
            )
        ]
    }
}
