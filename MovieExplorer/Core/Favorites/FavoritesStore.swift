import Foundation
import Observation
import os
import SwiftData

@Observable
final class FavoritesStore {
    private(set) var favorites: [Favorite] = []
    private var keys: Set<String> = []

    private let container: ModelContainer
    private var context: ModelContext { container.mainContext }
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "MovieExplorer", category: "Favorites")

    init(container: ModelContainer) {
        self.container = container
        reload()
    }

    func isFavorite(id: Int, type: MediaType) -> Bool {
        keys.contains(FavoriteItem.key(id: id, type: type))
    }

    func toggle(_ item: FavoriteItem) {
        if let existing = favorites.first(where: { $0.key == item.key }) {
            context.delete(existing)
        } else {
            context.insert(Favorite(item: item))
        }
        saveAndReload()
    }

    func remove(_ favorite: Favorite) {
        context.delete(favorite)
        saveAndReload()
    }

    private func saveAndReload() {
        do {
            try context.save()
        } catch {
            logger.error("Saving favorites failed: \(error.localizedDescription, privacy: .public)")
        }
        reload()
    }

    private func reload() {
        let newestFirst = FetchDescriptor<Favorite>(sortBy: [SortDescriptor(\.addedAt, order: .reverse)])
        do {
            favorites = try context.fetch(newestFirst)
        } catch {
            logger.error("Loading favorites failed: \(error.localizedDescription, privacy: .public)")
            favorites = []
        }
        keys = Set(favorites.map(\.key))
    }
}

extension FavoritesStore {
    static func persistent() throws -> FavoritesStore {
        FavoritesStore(container: try ModelContainer(for: Favorite.self))
    }

    static func inMemory() throws -> FavoritesStore {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return FavoritesStore(container: try ModelContainer(for: Favorite.self, configurations: configuration))
    }
}
