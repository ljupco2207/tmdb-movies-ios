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
        #expect(TMDBImage.size(forPixelWidth: pixelWidth, kind: .backdrop) == expected)
    }

    @Test(arguments: [
        (180.0, "w185"),
        (186.0, "w342"),
        (900.0, "w780")
    ])
    func posterSizeCoversPixelWidth(pixelWidth: Double, expected: String) {
        #expect(TMDBImage.size(forPixelWidth: pixelWidth, kind: .poster) == expected)
    }

    @Test func urlUsesSizeMatchingPixelWidth() {
        let url = TMDBImage.url(path: "/abc.jpg", kind: .backdrop, pixelWidth: 1110)
        #expect(url?.absoluteString == "https://image.tmdb.org/t/p/w1280/abc.jpg")
    }

    @Test func noURLWithoutPathOrWidth() {
        #expect(TMDBImage.url(path: nil, kind: .backdrop, pixelWidth: 1110) == nil)
        #expect(TMDBImage.url(path: "/abc.jpg", kind: .backdrop, pixelWidth: 0) == nil)
    }
}
