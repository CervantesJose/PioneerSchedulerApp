//
//  CalendarRangeView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/9/25.
//

import Combine
import SwiftUI

struct DateRangeSelectorView: View {

    @StateObject private var viewModel = DateRangeSelectorViewModel()
    var container: DateRangeSelectorViewModelHolder
    let month: Date
    let calendar = Calendar.current

    var body: some View {
        let days = makeDays()
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.fixed(30))]) {
                ForEach(days, id: \.self) { date in
                    Text("\(calendar.component(.day, from: date))")
                        .frame(width: 44, height: 44)
                        .background {
                            viewModel.contains(date: date) ? Color.blue.opacity(0.3) : Color.clear
                        }
                        .cornerRadius(4)
                        .onTapGesture { viewModel.select(date) }
                }
            }
        }
    }

    func makeDays() -> [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: month) else {
            return []
        }
        var dates: [Date] = []
        var current = weekInterval.start

        while current <= weekInterval.end {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return dates
    }
}
