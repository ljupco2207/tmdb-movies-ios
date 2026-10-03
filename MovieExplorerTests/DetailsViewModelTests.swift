import Foundation
@testable import MovieExplorer
import Testing

@MainActor
struct DetailsViewModelTests {
    @Test func loadsDetailsForMovie() async throws {
        let details = try APIClient.decode(MovieDetails.self, from: Data(SampleResponses.movieDetails.utf8))
        let api = MockAPIClient { endpoint in
            guard case .movieDetails(id: 1) = endpoint else { throw APIError.badStatus(404) }
            return details
        }
        let viewModel = DetailsViewModel(movieID: 1, api: api)

        await viewModel.load()

        guard case .loaded(let loaded) = viewModel.state else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(loaded.title == "Digger")
    }

    @Test func failureSetsFailedState() async {
        let viewModel = DetailsViewModel(movieID: 1, api: MockAPIClient { _ in throw APIError.badStatus(500) })

        await viewModel.load()

        guard case .failed = viewModel.state else {
            Issue.record("Expected failed state")
            return
        }
    }
}
