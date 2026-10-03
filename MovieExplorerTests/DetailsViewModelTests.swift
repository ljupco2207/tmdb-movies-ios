import Foundation
@testable import MovieExplorer
import Testing

@MainActor
struct DetailsViewModelTests {
    @Test func loadsDetailsForMovie() async throws {
        let details = try APIClient.decode(MediaDetails.self, from: Data(SampleResponses.movieDetails.utf8))
        let api = MockAPIClient { endpoint in
            guard case .movieDetails(id: 1) = endpoint else { throw APIError.badStatus(404) }
            return details
        }
        let viewModel = DetailsViewModel(id: 1, type: .movie, api: api)

        await viewModel.load()

        guard case .loaded(let loaded) = viewModel.state else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(loaded.displayTitle == "Digger")
    }

    @Test func loadsDetailsForSeries() async throws {
        let details = try APIClient.decode(MediaDetails.self, from: Data(SampleResponses.seriesDetails.utf8))
        let api = MockAPIClient { endpoint in
            guard case .tvDetails(id: 2) = endpoint else { throw APIError.badStatus(404) }
            return details
        }
        let viewModel = DetailsViewModel(id: 2, type: .tv, api: api)

        await viewModel.load()

        guard case .loaded(let loaded) = viewModel.state else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(loaded.displayTitle == "Dark")
        #expect(viewModel.favoriteItem == FavoriteItem(id: 2, type: .tv, title: "Dark", posterPath: nil, year: "2017"))
    }

    @Test func failureSetsFailedState() async {
        let viewModel = DetailsViewModel(id: 1, type: .movie, api: MockAPIClient { _ in throw APIError.badStatus(500) })

        await viewModel.load()

        guard case .failed = viewModel.state else {
            Issue.record("Expected failed state")
            return
        }
    }
}
