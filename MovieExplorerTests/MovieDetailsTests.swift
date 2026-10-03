import Foundation
@testable import MovieExplorer
import Testing

struct MovieDetailsTests {
    @Test func decodesDetailsWithCredits() throws {
        let details = try APIClient.decode(MovieDetails.self, from: Data(SampleResponses.movieDetails.utf8))

        #expect(details.title == "Digger")
        #expect(details.year == "2026")
        #expect(details.runtimeText == "2h 9m")
        #expect(details.credits.cast.first?.name == "Tom Cruise")
    }

    @Test func directorsAndWritersAreDeduplicated() throws {
        let details = try APIClient.decode(MovieDetails.self, from: Data(SampleResponses.movieDetails.utf8))

        #expect(details.directors == ["A. Director"])
        #expect(details.writers == ["A. Director", "B. Writer"])
    }
}
