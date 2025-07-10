//
//  SectionTitle.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/10/25.
//

import SwiftUI

struct SectionTitle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.secondary)
    }
}

extension View {
    func sectionTitle() -> some View {
        modifier(SectionTitle())
    }
}
