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

    @Test func tvDetailsURLIncludesCredits() {
        #expect(Endpoint.tvDetails(id: 7).url?.absoluteString == "https://api.themoviedb.org/3/tv/7?append_to_response=credits")
    }

    @Test func searchURLsEncodeQuery() {
        #expect(Endpoint.searchMovies(query: "star wars").url?.absoluteString == "https://api.themoviedb.org/3/search/movie?query=star%20wars")
        #expect(Endpoint.searchTV(query: "dark").url?.absoluteString == "https://api.themoviedb.org/3/search/tv?query=dark")
    }
}
