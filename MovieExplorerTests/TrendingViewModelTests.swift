@testable import MovieExplorer
import Testing

@MainActor
struct TrendingViewModelTests {
    @Test func loadShowsFirstTrendingPage() async {
        let page = MoviePage(page: 1, totalPages: 3, results: [movie(1), movie(2)])
        let api = MockAPIClient { endpoint in
            guard case .trending(page: 1) = endpoint else { throw APIError.badStatus(404) }
            return page
        }
        let viewModel = TrendingViewModel(api: api)

        await viewModel.load()

        #expect(viewModel.movies.map(\.id) == [1, 2])
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isLoading)
    }

    @Test func failureShowsErrorMessage() async {
        let viewModel = TrendingViewModel(api: MockAPIClient { _ in throw APIError.badStatus(500) })

        await viewModel.load()

        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(!viewModel.isLoading)
    }

    private func movie(_ id: Int) -> Movie {
        Movie(id: id, title: "Movie \(id)", overview: "", backdropPath: nil)
    }
}
