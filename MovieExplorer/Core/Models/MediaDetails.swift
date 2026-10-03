nonisolated struct MediaDetails: Decodable, Sendable, MediaDisplayable {
    let id: Int
    let tagline: String?
    let overview: String
    let backdropPath: String?
    let posterPath: String?
    let status: String?
    let voteAverage: Double
    let voteCount: Int
    let genres: [Genre]
    let credits: Credits

    // Movie
    let title: String?
    let releaseDate: String?
    let runtime: Int?

    // Series
    let name: String?
    let firstAirDate: String?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let createdBy: [Creator]?

    nonisolated struct Genre: Decodable, Sendable {
        let name: String
    }

    nonisolated struct Creator: Decodable, Sendable {
        let name: String
    }

    nonisolated struct Credits: Decodable, Sendable {
        let cast: [CastMember]
        let crew: [CrewMember]
    }

    nonisolated struct CastMember: Decodable, Sendable, Identifiable {
        let creditId: String
        let name: String
        let character: String?

        var id: String { creditId }
    }

    nonisolated struct CrewMember: Decodable, Sendable {
        let name: String
        let job: String
        let department: String
    }
}

nonisolated extension MediaDetails {
    var runtimeText: String? {
        guard let runtime, runtime > 0 else { return nil }
        return runtime >= 60 ? "\(runtime / 60)h \(runtime % 60)m" : "\(runtime)m"
    }

    var seasonsText: String? {
        guard let numberOfSeasons, numberOfSeasons > 0 else { return nil }
        return numberOfSeasons.counted("season")
    }

    var episodesText: String? {
        guard let numberOfEpisodes, numberOfEpisodes > 0 else { return nil }
        return numberOfEpisodes.counted("episode")
    }

    var creators: [String] {
        (createdBy ?? []).map(\.name).uniqued()
    }

    var directors: [String] {
        credits.crew.filter { $0.job == "Director" }.map(\.name).uniqued()
    }

    var writers: [String] {
        credits.crew.filter { $0.department == "Writing" }.map(\.name).uniqued()
    }
}

nonisolated private extension Array where Element: Hashable {
    /// Removes duplicates, keeping the first occurrence.
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
