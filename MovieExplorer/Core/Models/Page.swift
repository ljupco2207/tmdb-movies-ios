nonisolated struct Page<Item: Decodable & Sendable>: Decodable, Sendable {
    let page: Int
    let totalPages: Int
    let results: [Item]
}
