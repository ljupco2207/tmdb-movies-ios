import Foundation

nonisolated enum Endpoint: Sendable {
    case trending(page: Int)

    var path: String {
        switch self {
        case .trending: "/trending/movie/week"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .trending(let page): [URLQueryItem(name: "page", value: String(page))]
        }
    }

    var url: URL? {
        var components = URLComponents(url: APIConfig.baseURL.appending(path: path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url
    }
}
