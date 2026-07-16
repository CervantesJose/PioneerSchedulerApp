//
//  BackgroundView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/4/25.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(Gradient(colors: [
                Color("backgroundColor"),
                Color("secondaryBackgroundColor")
            ]))
    }
}
