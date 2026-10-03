import SwiftUI

struct RootView: View {
    let api: APIClientProtocol
    let favorites: FavoritesStore
    let network: NetworkMonitor

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            TrendingView(api: api, favorites: favorites) { path.append($0) }
                .navigationDestination(for: MediaRoute.self) { route in
                    DetailsView(route: route, api: api, favorites: favorites)
                }
                .navigationDestination(for: SearchRoute.self) { _ in
                    SearchView(api: api, favorites: favorites)
                }
                .navigationDestination(for: FavoritesRoute.self) { _ in
                    FavoritesView(favorites: favorites)
                }
        }
        .overlay(alignment: .bottom) {
            if !network.isConnected {
                OfflineBanner()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: network.isConnected)
    }
}
