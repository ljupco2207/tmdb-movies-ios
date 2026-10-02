nonisolated struct Movie: Decodable, Sendable, Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String?
}
