import SwiftUI

struct OrSeparatorView: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.secondary)

            Text("OR")
                .foregroundStyle(.secondary)

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
    }
}
