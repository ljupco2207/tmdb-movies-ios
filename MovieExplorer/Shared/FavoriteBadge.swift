import SwiftUI

struct FavoriteBadge: View {
    var body: some View {
        Image(systemName: "heart.fill")
            .foregroundStyle(.red)
            .accessibilityLabel("Favorite")
    }
}
