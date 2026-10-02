import SwiftUI

@main
struct MovieExplorerApp: App {
    private let api = APIClient()

    var body: some Scene {
        WindowGroup {
            TrendingView(api: api)
        }
    }
}
