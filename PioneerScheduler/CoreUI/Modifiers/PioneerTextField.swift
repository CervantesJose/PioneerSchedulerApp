//
//  PioneerTextField.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 8/2/25.
//

import SwiftUI

struct PioneerTextField: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding()
            .background(.regularMaterial)
            .cornerRadius(10)
    }
}

extension View {
    func pioneerTextField() -> some View {
        modifier(PioneerTextField())
    }
}
