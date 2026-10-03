import Foundation
@testable import MovieExplorer
import Testing

struct TMDBImageTests {
    @Test(arguments: [
        (100.0, "w300"),
        (300.0, "w300"),
        (680.0, "w780"),
        (1110.0, "w1280"),
        (2000.0, "w1280")
    ])
    func backdropSizeCoversPixelWidth(pixelWidth: Double, expected: String) {
        #expect(TMDBImage.backdropSize(forPixelWidth: pixelWidth) == expected)
    }

    @Test func urlUsesSizeMatchingPixelWidth() {
        let url = TMDBImage.backdropURL(path: "/abc.jpg", pixelWidth: 1110)
        #expect(url?.absoluteString == "https://image.tmdb.org/t/p/w1280/abc.jpg")
    }

    @Test func noURLWithoutPathOrWidth() {
        #expect(TMDBImage.backdropURL(path: nil, pixelWidth: 1110) == nil)
        #expect(TMDBImage.backdropURL(path: "/abc.jpg", pixelWidth: 0) == nil)
    }
}
