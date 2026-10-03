import SwiftUI

struct TrendingView: View {
    @State private var viewModel: TrendingViewModel

    init(api: APIClientProtocol) {
        _viewModel = State(initialValue: TrendingViewModel(api: api))
    }

    var body: some View {
        NavigationStack {
            MovieCollectionView(movies: viewModel.movies, onReachEnd: loadNextPage) {
                PagingFooter(viewModel: viewModel, retry: loadNextPage)
            }
            .ignoresSafeArea()
            .overlay { loadingOrError }
            .navigationTitle("Trending")
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
                ContentUnavailableView {
                    Label(errorMessage, systemImage: "wifi.exclamationmark")
                } actions: {
                    Button("Retry", action: loadNextPage)
                }
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
