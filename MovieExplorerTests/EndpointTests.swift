import Foundation
@testable import MovieExplorer
import Testing

struct EndpointTests {
    @Test func trendingURLIncludesPage() {
        #expect(Endpoint.trending(page: 2).url?.absoluteString == "https://api.themoviedb.org/3/trending/movie/week?page=2")
    }

    @Test func movieDetailsURLIncludesCredits() {
        #expect(Endpoint.movieDetails(id: 42).url?.absoluteString == "https://api.themoviedb.org/3/movie/42?append_to_response=credits")
    }
}
