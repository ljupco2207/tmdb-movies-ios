import Foundation
@testable import MovieExplorer
import Testing

struct MediaDetailsTests {
    @Test func decodesMovieDetails() throws {
        let details = try APIClient.decode(MediaDetails.self, from: Data(SampleResponses.movieDetails.utf8))

        #expect(details.displayTitle == "Digger")
        #expect(details.year == "2026")
        #expect(details.runtimeText == "2h 9m")
        #expect(details.credits.cast.first?.name == "Tom Cruise")
    }

    @Test func directorsAndWritersAreDeduplicated() throws {
        let details = try APIClient.decode(MediaDetails.self, from: Data(SampleResponses.movieDetails.utf8))

        #expect(details.directors == ["A. Director"])
        #expect(details.writers == ["A. Director", "B. Writer"])
    }

    @Test func decodesSeriesDetails() throws {
        let details = try APIClient.decode(MediaDetails.self, from: Data(SampleResponses.seriesDetails.utf8))

        #expect(details.displayTitle == "Dark")
        #expect(details.year == "2017")
        #expect(details.runtimeText == nil)
        #expect(details.seasonsText == "3 seasons")
        #expect(details.episodesText == "26 episodes")
        #expect(details.creators == ["Baran bo Odar", "Jantje Friese"])
    }
}
