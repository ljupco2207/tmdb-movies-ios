@testable import MovieExplorer
import XCTest

@MainActor
final class SearchDebounceTests: XCTestCase {
    func testNoRequestIsSentBeforeTypingPauses() async {
        let requestSent = expectation(description: "No request during the debounce")
        requestSent.isInverted = true
        let viewModel = SearchViewModel(api: mockAPI(onRequest: { _ in requestSent.fulfill() }), debounce: .seconds(1))

        viewModel.query = "dune"

        await fulfillment(of: [requestSent], timeout: 0.3)
        viewModel.query = ""
    }

    func testOnlyLastQueryIsSentAfterTypingPauses() async {
        let requestSent = expectation(description: "Only one request once typing pauses")
        requestSent.assertForOverFulfill = true
        let viewModel = SearchViewModel(
            api: mockAPI(onRequest: { endpoint in
                XCTAssertEqual(endpoint.url?.absoluteString, "https://api.themoviedb.org/3/search/movie?query=dune")
                requestSent.fulfill()
            }),
            debounce: .milliseconds(100)
        )

        viewModel.query = "d"
        viewModel.query = "du"
        viewModel.query = "dune"

        await fulfillment(of: [requestSent], timeout: 2)
    }

    private func mockAPI(onRequest: @escaping @Sendable (Endpoint) -> Void) -> MockAPIClient {
        MockAPIClient { endpoint in
            onRequest(endpoint)
            return Page<SearchResult>(page: 1, totalPages: 1, results: [])
        }
    }
}
