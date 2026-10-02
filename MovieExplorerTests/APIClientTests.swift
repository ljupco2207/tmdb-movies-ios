import Foundation
@testable import MovieExplorer
import Testing

struct APIClientTests {
    @Test func requestHasBearerTokenAndJSONHeaders() throws {
        let request = try APIClient().makeRequest(for: .trending(page: 1))

        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer \(APIConfig.accessToken)")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test func successfulResponseIsDecoded() async throws {
        let client = APIClient(session: MockNetworkSession(status: 200, body: SampleResponses.trendingPage))

        let page: MoviePage = try await client.request(.trending(page: 1))

        #expect(page.totalPages == 500)
        #expect(page.results.first?.title == "Digger")
    }

    @Test func nonSuccessStatusThrowsBadStatus() async {
        let client = APIClient(session: MockNetworkSession(status: 404))

        await #expect(throws: APIError.badStatus(404)) {
            let _: MoviePage = try await client.request(.trending(page: 1))
        }
    }
}
