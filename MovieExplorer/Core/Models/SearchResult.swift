nonisolated struct SearchResult: Decodable, Sendable, Identifiable {
    let id: Int
    let overview: String
    let posterPath: String?

    // Movie
    let title: String?
    let releaseDate: String?

    // Series
    let name: String?
    let firstAirDate: String?

    var displayTitle: String { title ?? name ?? "" }

    var year: String? {
        guard let date = releaseDate ?? firstAirDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }
}
