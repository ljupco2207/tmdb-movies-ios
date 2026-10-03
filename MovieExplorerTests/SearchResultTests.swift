@testable import MovieExplorer
import Testing

struct SearchResultTests {
    @Test func movieUsesTitleAndReleaseYear() {
        let movie = SearchResult(
            id: 1, overview: "", posterPath: nil, title: "Dune", releaseDate: "2021-09-15", name: nil, firstAirDate: nil
        )
        #expect(movie.displayTitle == "Dune")
        #expect(movie.year == "2021")
    }

    @Test func seriesUsesNameAndFirstAirYear() {
        let series = SearchResult(
            id: 2, overview: "", posterPath: nil, title: nil, releaseDate: nil, name: "Dark", firstAirDate: "2017-12-01"
        )
        #expect(series.displayTitle == "Dark")
        #expect(series.year == "2017")
    }
}
