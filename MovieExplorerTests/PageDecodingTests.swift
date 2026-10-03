import Foundation
@testable import MovieExplorer
import Testing

struct PageDecodingTests {
    @Test func decodesTrendingPage() throws {
        let page = try APIClient.decode(Page<Movie>.self, from: Data(SampleResponses.trendingPage.utf8))

        #expect(page.page == 1)
        #expect(page.totalPages == 500)
        #expect(page.results.count == 2)
        #expect(page.results[0].title == "Digger")
        #expect(page.results[0].backdropPath == "/b7t3r39Oll5qPxBKzLZ8eHMBD7l.jpg")
        #expect(page.results[1].backdropPath == nil)
    }

    @Test func invalidJSONThrowsDecodingError() {
        #expect(throws: APIError.decoding) {
            try APIClient.decode(Page<Movie>.self, from: Data("{}".utf8))
        }
    }
}
