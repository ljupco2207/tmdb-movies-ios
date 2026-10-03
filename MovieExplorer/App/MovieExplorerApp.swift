import Kingfisher
import SwiftUI

@main
struct MovieExplorerApp: App {
    private let api = Self.makeAPI()
    @State private var network = NetworkMonitor()

    init() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        ImageCache.default.diskStorage.config.sizeLimit = 200 * 1024 * 1024
    }

    var body: some Scene {
        WindowGroup {
            TrendingView(api: api)
                .overlay(alignment: .bottom) {
                    if !network.isConnected {
                        OfflineBanner()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut, value: network.isConnected)
        }
    }

    private static func makeAPI() -> APIClient {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            return APIClient(session: UITestNetworkSession(), cache: nil)
        }
        #endif
        return APIClient()
    }
}
