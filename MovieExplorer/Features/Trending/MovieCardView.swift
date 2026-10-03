import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let favorites: FavoritesStore

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TMDBImageView(path: movie.backdropPath, kind: .backdrop)
                .aspectRatio(16 / 9, contentMode: .fit)
                .overlay(alignment: .topTrailing) {
                    if favorites.isFavorite(id: movie.id, type: .movie) {
                        FavoriteBadge()
                            .padding(8)
                            .background(.regularMaterial, in: .circle)
                            .padding(8)
                    }
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2, reservesSpace: true)

                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3, reservesSpace: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}
