import Foundation
import os

/// The app's services, created once at launch; the one place that chooses implementations.
struct AppDependencies {
    let api: APIClientProtocol
    let favorites: FavoritesStore
    let network: NetworkMonitor

    static func makeDefault() -> AppDependencies {
        AppDependencies(api: makeAPI(), favorites: makeFavorites(), network: NetworkMonitor())
    }

    private static let isUITesting = ProcessInfo.processInfo.arguments.contains("--uitesting")

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
