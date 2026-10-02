import Foundation

nonisolated enum APIError: Error, Equatable {
    case invalidURL
    case badStatus(Int)
    case decoding
}

nonisolated protocol APIClientProtocol: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T
}

nonisolated final class APIClient: APIClientProtocol {
    private let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    /// Runs off the main actor, so JSON decoding never happens on the main thread.
    @concurrent
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await session.send(makeRequest(for: endpoint))

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard (200..<300).contains(statusCode) else {
            throw APIError.badStatus(statusCode)
        }

        return try Self.decode(T.self, from: data)
    }

    func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIConfig.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}
