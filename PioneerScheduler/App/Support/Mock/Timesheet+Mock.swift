import Foundation

extension TimesheetWithWorkdays {
    static func mockData() -> [TimesheetWithWorkdays] {
        [
            TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: Calendar.current.date(from: .init(year: 1998, month: 04, day: 20)) ?? .now,
                endDate: Calendar.current.date(from: .init(year: 1998, month: 04, day: 24)) ?? .now,
                workday: Workday.mockData()
            )
        ]
    }
}
