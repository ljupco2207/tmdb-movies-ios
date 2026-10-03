import SwiftUI

@main
struct MovieExplorerApp: App {
    private let api = Self.makeAPI()

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
