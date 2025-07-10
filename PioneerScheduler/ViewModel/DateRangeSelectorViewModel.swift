//
//  DateRangeSelectorViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/10/25.
//

import Combine
import SwiftUI

class DateRangeSelectorViewModel: ObservableObject {
    @Published var selectedRange: DateRange?

    func select(_ date: Date) {
        if let range = selectedRange {
            selectedRange = DateRange(start: range.start, end: range.end)
        } else {
            selectedRange = DateRange(start: date, end: date)
        }
    }

    func reset() {
        selectedRange = nil
    }

    func contains(date: Date) -> Bool {
        guard let range = selectedRange else { return false }
        return (range.start ... range.end).contains(date)
    }
}

final class DateRangeSelectorViewModelHolder: ObservableObject {
    @Binding var selectedRange: DateRange?

    init(selectedRange: Binding<DateRange?>) {
        self._selectedRange = selectedRange
    }
}
