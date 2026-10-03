import Foundation
@testable import MovieExplorer
import Testing

struct APIConfigTests {
    @Test func valuesComeFromXcconfig() {
        #expect(APIConfig.baseURL.absoluteString == "https://api.themoviedb.org/3")
        #expect(APIConfig.imageBaseURL.absoluteString == "https://image.tmdb.org/t/p")
        #expect(!APIConfig.accessToken.isEmpty)
    }
}
