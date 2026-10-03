@testable import MovieExplorer
import XCTest

final class APIClientTests: XCTestCase {
    func testRequestHasBearerTokenAndJSONHeaders() throws {
        let request = try APIClient().makeRequest(for: .trending(page: 1))

        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(APIConfig.accessToken)")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func testSuccessfulResponseIsDecoded() async throws {
        let client = APIClient(session: MockNetworkSession(status: 200, body: SampleResponses.trendingPage))

        let page: Page<Movie> = try await client.request(.trending(page: 1))

        XCTAssertEqual(page.totalPages, 500)
        XCTAssertEqual(page.results.first?.title, "Digger")
    }

    func testNonSuccessStatusThrowsBadStatus() async {
        let client = APIClient(session: MockNetworkSession(status: 404))

        do {
            let _: Page<Movie> = try await client.request(.trending(page: 1))
            XCTFail("Expected badStatus(404)")
        } catch {
            XCTAssertEqual(error as? APIError, .badStatus(404))
        }
    }
}
