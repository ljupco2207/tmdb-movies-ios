nonisolated struct SearchResult: Decodable, Sendable, Identifiable, MediaDisplayable {
    let id: Int
    let overview: String
    let posterPath: String?

    // Movie
    let title: String?
    let releaseDate: String?

    // Series
    let name: String?
    let firstAirDate: String?
}
