import SwiftUI

struct FavoritesView: View {
    let favorites: FavoritesStore

    var body: some View {
        List {
            ForEach(favorites.favorites) { favorite in
                NavigationLink(value: MediaRoute(id: favorite.tmdbID, type: favorite.mediaType)) {
                    MediaRow(title: favorite.title, year: favorite.year, posterPath: favorite.posterPath)
                }
            }
            .onDelete { offsets in
                offsets.map { favorites.favorites[$0] }.forEach(favorites.remove)
            }
        }
        .listStyle(.plain)
        .overlay {
            if favorites.favorites.isEmpty {
                ContentUnavailableView(
                    "No favorites yet",
                    systemImage: "heart",
                    description: Text("Tap the heart on a movie or series to save it here.")
                )
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
}
