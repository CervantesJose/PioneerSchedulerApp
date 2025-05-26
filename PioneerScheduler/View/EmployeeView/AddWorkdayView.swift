//
//  WorkdayView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 10/22/24.
//

import SwiftUI

struct AddWorkdayView: View {
    @State private var location = ""
    @State private var duration = ""
    @State private var task = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Location", text: $location)
                TextField("Duration", text: $duration)
                TextField("Task", text: $task, axis: .vertical)
            }
        }
    }
}

#Preview {
    AddWorkdayView()
}
