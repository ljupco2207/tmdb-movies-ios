nonisolated struct Movie: Decodable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String?
}
