import Kingfisher
import SwiftUI

@main
struct MovieExplorerApp: App {
    private let dependencies = AppDependencies.makeDefault()

    init() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        ImageCache.default.diskStorage.config.sizeLimit = 200 * 1024 * 1024
    }

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}
