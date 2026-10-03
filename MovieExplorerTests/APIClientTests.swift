@testable import MovieExplorer
import XCTest

final class APIClientTests: XCTestCase {
    func testRequestHasBearerTokenAndJSONHeaders() throws {
        let request = try APIClient().makeRequest(for: .trending(page: 1))

        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(APIConfig.accessToken)")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func testSuccessfulResponseIsDecoded() async throws {
        let client = APIClient(session: MockNetworkSession(body: SampleResponses.trendingPage), cache: nil)

        let page: Page<Movie> = try await client.request(.trending(page: 1))

        XCTAssertEqual(page.totalPages, 500)
        XCTAssertEqual(page.results.first?.title, "Digger")
    }

    func testNonSuccessStatusThrowsBadStatus() async {
        let client = APIClient(session: MockNetworkSession(status: 404), cache: nil)

        do {
            let _: Page<Movie> = try await client.request(.trending(page: 1))
            XCTFail("Expected badStatus(404)")
        } catch {
            XCTAssertEqual(error as? APIError, .badStatus(404))
        }
    }

    func testOfflineReturnsSavedResponse() async throws {
        let cache = makeCache()
        let online = APIClient(session: MockNetworkSession(body: SampleResponses.trendingPage), cache: cache)
        let _: Page<Movie> = try await online.request(.trending(page: 1))

        let offline = APIClient(session: MockNetworkSession(error: URLError(.notConnectedToInternet)), cache: cache)
        let page: Page<Movie> = try await offline.request(.trending(page: 1))

        XCTAssertEqual(page.results.first?.title, "Digger")
    }

    func testOfflineWithoutSavedResponseThrows() async {
        let client = APIClient(session: MockNetworkSession(error: URLError(.notConnectedToInternet)), cache: makeCache())

        do {
            let _: Page<Movie> = try await client.request(.trending(page: 1))
            XCTFail("Expected notConnectedToInternet")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }

    func testServerErrorDoesNotUseSavedResponse() async throws {
        let cache = makeCache()
        let online = APIClient(session: MockNetworkSession(body: SampleResponses.trendingPage), cache: cache)
        let _: Page<Movie> = try await online.request(.trending(page: 1))

        let failing = APIClient(session: MockNetworkSession(status: 500), cache: cache)
        do {
            let _: Page<Movie> = try await failing.request(.trending(page: 1))
            XCTFail("Expected badStatus(500)")
        } catch {
            XCTAssertEqual(error as? APIError, .badStatus(500))
        }
    }

    private func makeCache() -> ResponseCache {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        addTeardownBlock { try? FileManager.default.removeItem(at: directory) }
        return ResponseCache(directory: directory)
    }
}
