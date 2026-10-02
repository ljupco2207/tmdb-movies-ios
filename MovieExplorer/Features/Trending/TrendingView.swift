import SwiftUI

struct TrendingView: View {
    @State private var viewModel: TrendingViewModel

    init(api: APIClientProtocol) {
        _viewModel = State(initialValue: TrendingViewModel(api: api))
    }

    var body: some View {
        NavigationStack {
            MovieCollectionView(movies: viewModel.movies)
                .ignoresSafeArea()
                .overlay { loadingOrError }
                .navigationTitle("Trending")
                .task {
                    if viewModel.movies.isEmpty {
                        await viewModel.load()
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
                    Button("Retry") {
                        Task { await viewModel.load() }
                    }
                }
            } else {
                ProgressView()
            }
        }
    }
}
