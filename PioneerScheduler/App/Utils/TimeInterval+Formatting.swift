import Foundation

extension TimeInterval {
    /// A compact "hours and minutes" representation, e.g. `7h:30m`.
    var asHourMinuteString: String {
        let totalMinutes = Int(self / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return String(format: "%dh:%02dm", hours, minutes)
    }
}
