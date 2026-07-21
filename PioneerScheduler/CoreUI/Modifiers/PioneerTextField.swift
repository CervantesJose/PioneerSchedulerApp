import SwiftUI

struct PioneerTextField: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding()
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func pioneerTextField() -> some View {
        modifier(PioneerTextField())
    }
}
