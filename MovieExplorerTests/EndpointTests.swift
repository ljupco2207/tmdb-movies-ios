import Foundation
@testable import MovieExplorer
import Testing

struct EndpointTests {
    @Test func trendingURLIncludesPage() {
        #expect(Endpoint.trending(page: 2).url?.absoluteString == "https://api.themoviedb.org/3/trending/movie/week?page=2")
    }
}
