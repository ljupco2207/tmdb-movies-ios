import Foundation
@testable import MovieExplorer
import os
import Testing

@MainActor
struct SearchViewModelTests {
    @Test func fastTypingSendsOnlyLastQuery() async {
        let recorder = SearchRecorder()
        let viewModel = SearchViewModel(api: recorder.api, debounce: .milliseconds(50))

        viewModel.query = "d"
        viewModel.query = "du"
        viewModel.query = "dune"
        await viewModel.searchTask?.value

        #expect(recorder.requestedURLs == ["https://api.themoviedb.org/3/search/movie?query=dune"])
        #expect(viewModel.results.map(\.displayTitle) == ["dune"])
    }

    @Test func switchingToSeriesSearchesTV() async {
        let recorder = SearchRecorder()
        let viewModel = SearchViewModel(api: recorder.api, debounce: .milliseconds(50))

        viewModel.query = "dark"
        viewModel.mediaType = .tv
        await viewModel.searchTask?.value

        #expect(recorder.requestedURLs == ["https://api.themoviedb.org/3/search/tv?query=dark"])
        #expect(viewModel.resultsType == .tv)
    }

    @Test func emptyQueryClearsResultsWithoutRequest() async {
        let recorder = SearchRecorder()
        let viewModel = SearchViewModel(api: recorder.api, debounce: .milliseconds(50))

        viewModel.query = "dune"
        await viewModel.searchTask?.value
        viewModel.query = "   "

        #expect(viewModel.results.isEmpty)
        #expect(recorder.requestedURLs.count == 1)
    }

    @Test func failureShowsError() async {
        let viewModel = SearchViewModel(api: MockAPIClient { _ in throw APIError.badStatus(500) }, debounce: .milliseconds(50))

        viewModel.query = "dune"
        await viewModel.searchTask?.value

        #expect(viewModel.errorMessage != nil)
        #expect(!viewModel.isLoading)
    }
}

/// Records every requested URL and answers each search with one result named after the query.
private final class SearchRecorder: Sendable {
    private let urls = OSAllocatedUnfairLock<[String]>(initialState: [])

    var requestedURLs: [String] { urls.withLock { $0 } }

    var api: MockAPIClient {
        MockAPIClient { [urls] endpoint in
            urls.withLock { $0.append(endpoint.url?.absoluteString ?? "") }
            let query = endpoint.queryItems.first { $0.name == "query" }?.value ?? ""
            let result = SearchResult(id: 1, overview: "", posterPath: nil, title: query, releaseDate: nil, name: nil, firstAirDate: nil)
            return Page(page: 1, totalPages: 1, results: [result])
        }
    }
}
