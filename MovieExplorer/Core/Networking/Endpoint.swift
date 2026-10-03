import Foundation

nonisolated enum Endpoint: Sendable {
    case trending(page: Int)
    case movieDetails(id: Int)
    case searchMovies(query: String)
    case searchTV(query: String)

    var path: String {
        switch self {
        case .trending:
            "/trending/movie/week"
        case .movieDetails(let id):
            "/movie/\(id)"
        case .searchMovies:
            "/search/movie"
        case .searchTV:
            "/search/tv"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .trending(let page):
            [URLQueryItem(name: "page", value: String(page))]
        case .movieDetails:
            [URLQueryItem(name: "append_to_response", value: "credits")]
        case .searchMovies(let query), .searchTV(let query):
            [URLQueryItem(name: "query", value: query)]
        }
    }

    var url: URL? {
        var components = URLComponents(url: APIConfig.baseURL.appending(path: path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url
    }
}
