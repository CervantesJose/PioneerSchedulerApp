import SwiftUI

struct TimesheetPDFView: View {

    let timesheet: TimesheetWithWorkdays
    let workdays: [Workday]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(
                "\(timesheet.startDate.formatted(date: .numeric, time: .omitted)) - \(timesheet.endDate.formatted(date: .numeric, time: .omitted))"
            )
                .font(.title)
                .bold()

            Divider()

            ForEach(workdays) { workday in
                VStack(alignment: .leading, spacing: 4) {
                    Text(workday.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)

                    if workday.tasks.isEmpty == false {
                        Text(workday.tasks.joined(separator: "\n"))
                            .font(.subheadline)
                    }

                    Text("Time worked: \(workday.duration.asHourMinuteString)")
                        .font(.subheadline)
                        .italic()
                }
                .padding(.vertical, 4)
            }

            Divider()

            Text("Total hours: \(workdays.reduce(0) { $0 + $1.duration }.asHourMinuteString)")
                .font(.headline)
        }
        .padding()
    }
}
