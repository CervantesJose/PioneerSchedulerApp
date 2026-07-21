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
