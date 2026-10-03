@testable import MovieExplorer
import Testing

@MainActor
struct TrendingViewModelTests {
    @Test func loadsPagesInOrder() async {
        let viewModel = TrendingViewModel(api: mockAPI(pages: [
            1: MoviePage(page: 1, totalPages: 2, results: [movie(1), movie(2)]),
            2: MoviePage(page: 2, totalPages: 2, results: [movie(3)])
        ]))

        await viewModel.loadNextPage()
        await viewModel.loadNextPage()

        #expect(viewModel.movies.map(\.id) == [1, 2, 3])
        #expect(!viewModel.hasMorePages)
    }

    @Test func stopsAfterLastPage() async {
        let viewModel = TrendingViewModel(api: mockAPI(pages: [
            1: MoviePage(page: 1, totalPages: 1, results: [movie(1)])
        ]))

        await viewModel.loadNextPage()
        await viewModel.loadNextPage() // page 2 doesn't exist in the mock, so a request would set an error

        #expect(viewModel.movies.map(\.id) == [1])
        #expect(viewModel.errorMessage == nil)
    }

    @Test func removesDuplicatesAcrossPages() async {
        let viewModel = TrendingViewModel(api: mockAPI(pages: [
            1: MoviePage(page: 1, totalPages: 2, results: [movie(1), movie(2)]),
            2: MoviePage(page: 2, totalPages: 2, results: [movie(2), movie(3)])
        ]))

        await viewModel.loadNextPage()
        await viewModel.loadNextPage()

        #expect(viewModel.movies.map(\.id) == [1, 2, 3])
    }

    @Test func failureShowsErrorAndAllowsRetry() async {
        let viewModel = TrendingViewModel(api: mockAPI(pages: [:]))

        await viewModel.loadNextPage()

        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.hasMorePages)
        #expect(!viewModel.isLoading)
    }

    private func mockAPI(pages: [Int: MoviePage]) -> MockAPIClient {
        MockAPIClient { endpoint in
            guard case .trending(let page) = endpoint, let result = pages[page] else { throw APIError.badStatus(500) }
            return result
        }
    }

    private func movie(_ id: Int) -> Movie {
        Movie(id: id, title: "Movie \(id)", overview: "", backdropPath: nil)
    }
}
