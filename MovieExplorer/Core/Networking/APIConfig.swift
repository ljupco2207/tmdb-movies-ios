import Foundation

/// Token committed on purpose so reviewers can run the app; regenerate it after the review.
nonisolated enum APIConfig {
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    // swiftlint:disable:next line_length
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZGZjZDFiYjVlYTcxYjgxODk0YTQ5NDEyZmFlMTJkOSIsIm5iZiI6MTc5MDg5NTkyOC45NDgsInN1YiI6IjZhYmVlNzM4OTY4OGIxZmZjMDg5ZDFhNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.EGhgvKZInd4tKqbUUhgM2p3FXdCjOEBT_PnBpSzim_8"
}
