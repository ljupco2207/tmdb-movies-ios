import Kingfisher
import os
import SwiftUI

@main
struct MovieExplorerApp: App {
    private static let isUITesting = ProcessInfo.processInfo.arguments.contains("--uitesting")

    private let api = Self.makeAPI()
    @State private var favorites = Self.makeFavorites()
    @State private var network = NetworkMonitor()

    init() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        ImageCache.default.diskStorage.config.sizeLimit = 200 * 1024 * 1024
    }

    var body: some Scene {
        WindowGroup {
            RootView(api: api, favorites: favorites, network: network)
        }
    }

    private static func makeAPI() -> APIClient {
        #if DEBUG
        if isUITesting {
            return APIClient(session: UITestNetworkSession(), cache: nil)
        }
        #endif
        return APIClient()
    }

    private static func makeFavorites() -> FavoritesStore {
        do {
            return try isUITesting ? .inMemory() : .persistent()
        } catch {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "MovieExplorer", category: "Favorites")
                .error("Opening favorites failed, using memory only: \(error.localizedDescription, privacy: .public)")
            do {
                return try .inMemory()
            } catch {
                fatalError("Couldn't create an in-memory favorites store: \(error)")
            }
        }
    }
}
