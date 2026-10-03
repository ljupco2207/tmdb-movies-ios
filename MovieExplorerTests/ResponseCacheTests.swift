import Foundation
@testable import MovieExplorer
import Testing

final class ResponseCacheTests {
    private let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
    private let cache: ResponseCache
    private let url = URL(string: "https://api.themoviedb.org/3/trending/movie/week?page=1")

    init() {
        cache = ResponseCache(directory: directory)
    }

    deinit {
        try? FileManager.default.removeItem(at: directory)
    }

    @Test func savedDataIsReturnedForSameURL() throws {
        let url = try #require(url)
        cache.save(Data("saved".utf8), for: url)

        #expect(cache.data(for: url) == Data("saved".utf8))
    }

    @Test func differentQueryHasNoSavedData() throws {
        cache.save(Data("page 1".utf8), for: try #require(url))

        let otherPage = try #require(URL(string: "https://api.themoviedb.org/3/trending/movie/week?page=2"))
        #expect(cache.data(for: otherPage) == nil)
    }
}
