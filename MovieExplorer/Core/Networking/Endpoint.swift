import Foundation

nonisolated enum Endpoint: Sendable {
    case trending(page: Int)
    case movieDetails(id: Int)

    var path: String {
        switch self {
        case .trending: "/trending/movie/week"
        case .movieDetails(let id): "/movie/\(id)"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .trending(let page): [URLQueryItem(name: "page", value: String(page))]
        case .movieDetails: [URLQueryItem(name: "append_to_response", value: "credits")]
        }
    }

    var url: URL? {
        var components = URLComponents(url: APIConfig.baseURL.appending(path: path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url
    }
}
