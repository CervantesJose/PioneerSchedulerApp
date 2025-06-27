//
//  PioneerButtonStyles.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/26/25.
//

import SwiftUI

struct PioneerButtonStyle: ViewModifier {

    private enum Constants {
        static let buttonPadding: CGFloat = 8
    }

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(.blue)
            .cornerRadius(Constants.buttonPadding)
            .padding([.horizontal, .top])
    }
}

extension View {
    func pioneerButtonStyle() -> some View {
        modifier(PioneerButtonStyle())
    }
}
