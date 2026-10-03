import SwiftUI

struct TrendingView: View {
    private let favorites: FavoritesStore
    /// The collection view is UIKit, so it can't use NavigationLink; RootView pushes the route.
    private let onOpen: (MediaRoute) -> Void
    @State private var viewModel: TrendingViewModel

    init(api: APIClientProtocol, favorites: FavoritesStore, onOpen: @escaping (MediaRoute) -> Void) {
        self.favorites = favorites
        self.onOpen = onOpen
        _viewModel = State(initialValue: TrendingViewModel(api: api))
    }

    var body: some View {
        MovieCollectionView(
            movies: viewModel.movies,
            favorites: favorites,
            onReachEnd: loadNextPage,
            onSelect: { onOpen(MediaRoute(id: $0.id, type: .movie)) },
            footer: { PagingFooter(viewModel: viewModel, retry: loadNextPage) }
        )
        .ignoresSafeArea()
        .overlay { loadingOrError }
        .navigationTitle("Trending")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: FavoritesRoute()) {
                    Image(systemName: "heart")
                }
                .accessibilityLabel("Favorites")
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: SearchRoute()) {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel("Search")
            }
        }
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.loadNextPage()
            }
        }
    }

    @ViewBuilder
    private var loadingOrError: some View {
        if viewModel.movies.isEmpty {
            if let errorMessage = viewModel.errorMessage {
                ErrorStateView(message: errorMessage, retry: loadNextPage)
            } else {
                ProgressView()
            }
        }
    }

    private func loadNextPage() {
        Task { await viewModel.loadNextPage() }
    }
}

private struct PagingFooter: View {
    let viewModel: TrendingViewModel
    let retry: () -> Void

    var body: some View {
        if !viewModel.movies.isEmpty {
            if viewModel.errorMessage != nil {
                Button("Retry", action: retry)
            } else if viewModel.hasMorePages {
                ProgressView()
            }
        }
    }
}
