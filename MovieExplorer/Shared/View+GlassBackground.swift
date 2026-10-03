import SwiftUI

extension View {
    @ViewBuilder
    func glassBackground(in shape: some InsettableShape = .capsule) -> some View {
        #if os(visionOS)
        glassBackgroundEffect(in: shape)
        #else
        if #available(iOS 26, *) {
            glassEffect(.regular, in: shape)
        } else {
            background(.ultraThinMaterial, in: shape)
                .environment(\.colorScheme, .dark)
        }
        #endif
    }
}
