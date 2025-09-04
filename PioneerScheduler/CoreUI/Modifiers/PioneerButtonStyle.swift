//
//  PioneerButtonStyles.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/26/25.
//

import SwiftUI

struct PioneerButtonStyle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(.blue)
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

extension View {
    func pioneerButtonStyle() -> some View {
        modifier(PioneerButtonStyle())
    }
}
