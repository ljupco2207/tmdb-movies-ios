import SwiftUI

struct TrendingView: View {
    private let api: APIClientProtocol
    @State private var viewModel: TrendingViewModel
    @State private var path: [Movie] = []

    init(api: APIClientProtocol) {
        self.api = api
        _viewModel = State(initialValue: TrendingViewModel(api: api))
    }

    var body: some View {
        NavigationStack(path: $path) {
            MovieCollectionView(
                movies: viewModel.movies,
                onReachEnd: loadNextPage,
                onSelect: { path.append($0) },
                footer: { PagingFooter(viewModel: viewModel, retry: loadNextPage) }
            )
            .ignoresSafeArea()
            .overlay { loadingOrError }
            .navigationTitle("Trending")
            .navigationDestination(for: Movie.self) { movie in
                DetailsView(movieID: movie.id, api: api)
            }
            .task {
                if viewModel.movies.isEmpty {
                    await viewModel.loadNextPage()
                }
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
