import SwiftUI

/// Poster, title, year and an optional overview; used by Search and Favorites.
struct MediaRow: View {
    let title: String
    let year: String?
    var overview = ""
    let posterPath: String?
    var isFavorite = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            TMDBImageView(path: posterPath, kind: .poster)
                .frame(width: 60, height: 90)
                .clipShape(.rect(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                if let year {
                    Text(year)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !overview.isEmpty {
                    Text(overview)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)

            if isFavorite {
                FavoriteBadge()
            }
        }
        .padding(.vertical, 4)
    }
}
