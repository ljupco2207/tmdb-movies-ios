nonisolated struct MoviePage: Decodable, Sendable {
    let page: Int
    let totalPages: Int
    let results: [Movie]
}
