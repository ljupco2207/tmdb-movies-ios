import SwiftUI

struct OfflineBanner: View {
    var body: some View {
        Label("Offline – showing saved content", systemImage: "wifi.slash")
            .font(.footnote.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.regularMaterial, in: .capsule)
            .padding(.bottom, 8)
    }
}
