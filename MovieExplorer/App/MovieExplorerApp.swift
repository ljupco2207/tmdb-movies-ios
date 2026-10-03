import Kingfisher
import SwiftUI

@main
struct MovieExplorerApp: App {
    private let api = Self.makeAPI()

    init() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        ImageCache.default.diskStorage.config.sizeLimit = 200 * 1024 * 1024
    }

    var body: some Scene {
        WindowGroup {
            TrendingView(api: api)
        }
    }

    private static func makeAPI() -> APIClient {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            return APIClient(session: UITestNetworkSession())
        }
        #endif
        return APIClient()
    }
}
