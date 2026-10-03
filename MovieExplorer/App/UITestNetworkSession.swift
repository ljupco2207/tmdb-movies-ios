#if DEBUG
import Foundation

/// Fixed responses for UI tests (launch argument `--uitesting`), so they never depend on the network.
nonisolated struct UITestNetworkSession: NetworkSession {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = request.url,
              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        else { throw URLError(.badURL) }
        return (try JSONSerialization.data(withJSONObject: Self.body(for: url)), response)
    }

    private static func body(for url: URL) -> [String: Any] {
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        let query = queryItems.first { $0.name == "query" }?.value ?? ""
        let page = queryItems.first { $0.name == "page" }?.value.flatMap(Int.init) ?? 1
        let id = Int(url.lastPathComponent) ?? 0
        let path = url.path()

        if path.hasSuffix("/trending/movie/week") {
            let movies = (1...10).map { movie(id: page * 100 + $0) }
            return ["page": page, "total_pages": 3, "results": movies]
        } else if path.hasSuffix("/search/movie") {
            return ["page": 1, "total_pages": 1, "results": [["id": 1, "title": "\(query) Movie", "overview": ""]]]
        } else if path.hasSuffix("/search/tv") {
            return ["page": 1, "total_pages": 1, "results": [["id": 2, "name": "\(query) Series", "overview": ""]]]
        } else if path.contains("/tv/") {
            return details(id: id, titleKey: "name", title: "Series \(id)")
        } else {
            return details(id: id, titleKey: "title", title: "Movie \(id)")
        }
    }

    private static func movie(id: Int) -> [String: Any] {
        ["id": id, "title": "Movie \(id)", "overview": "Overview of movie \(id)."]
    }

    private static func details(id: Int, titleKey: String, title: String) -> [String: Any] {
        [
            "id": id, titleKey: title, "overview": "Overview.", "vote_average": 7.5, "vote_count": 100,
            "genres": [], "credits": ["cast": [], "crew": []]
        ]
    }
}
#endif
