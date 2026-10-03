nonisolated struct MovieDetails: Decodable, Sendable {
    let id: Int
    let title: String
    let tagline: String?
    let overview: String
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let status: String?
    let voteAverage: Double
    let voteCount: Int
    let genres: [Genre]
    let credits: Credits

    nonisolated struct Genre: Decodable, Sendable {
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

nonisolated extension MovieDetails {
    var year: String? {
        guard let releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }

    var runtimeText: String? {
        guard let runtime, runtime > 0 else { return nil }
        return runtime >= 60 ? "\(runtime / 60)h \(runtime % 60)m" : "\(runtime)m"
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
