@testable import MovieExplorer
import Testing

@MainActor
struct FavoritesStoreTests {
    private let dune = FavoriteItem(id: 1, type: .movie, title: "Dune", posterPath: nil, year: "2021")

    @Test func toggleAddsAndRemoves() throws {
        let store = try FavoritesStore.inMemory()

        store.toggle(dune)
        #expect(store.isFavorite(id: 1, type: .movie))

        store.toggle(dune)
        #expect(!store.isFavorite(id: 1, type: .movie))
        #expect(store.favorites.isEmpty)
    }

    @Test func movieAndSeriesWithSameIDAreSeparate() throws {
        let store = try FavoritesStore.inMemory()

        store.toggle(dune)

        #expect(store.isFavorite(id: 1, type: .movie))
        #expect(!store.isFavorite(id: 1, type: .tv))
    }

    @Test func newestFavoriteComesFirst() throws {
        let store = try FavoritesStore.inMemory()

        store.toggle(dune)
        store.toggle(FavoriteItem(id: 2, type: .tv, title: "Dark", posterPath: nil, year: "2017"))

        #expect(store.favorites.map(\.title) == ["Dark", "Dune"])
    }

    @Test func removeDeletesFavorite() throws {
        let store = try FavoritesStore.inMemory()
        store.toggle(dune)

        store.remove(try #require(store.favorites.first))

        #expect(store.favorites.isEmpty)
    }
}
