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
    private let cache: ResponseCache?

    private static let offlineErrors: Set<URLError.Code> = [
        .notConnectedToInternet,
        .networkConnectionLost,
        .cannotConnectToHost,
        .cannotFindHost,
        .timedOut,
        .dataNotAllowed
    ]

    init(session: NetworkSession = URLSession.shared, cache: ResponseCache? = ResponseCache()) {
        self.session = session
        self.cache = cache
    }

    /// Runs off the main actor, so JSON decoding never happens on the main thread.
    @concurrent
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        let request = try makeRequest(for: endpoint)
        let start = ContinuousClock.now
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.send(request)
        } catch let error as URLError where Self.offlineErrors.contains(error.code) {
            NetworkLogger.log(request, error: error)
            guard let url = request.url, let saved = cache?.data(for: url) else { throw error }
            return try Self.decode(T.self, from: saved)
        } catch {
            NetworkLogger.log(request, error: error)
            throw error
        }

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        NetworkLogger.log(request, statusCode: statusCode, duration: ContinuousClock.now - start)
        guard (200..<300).contains(statusCode) else {
            throw APIError.badStatus(statusCode)
        }

        let decoded = try Self.decode(T.self, from: data)
        if let url = request.url {
            cache?.save(data, for: url)
        }
        return decoded
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
            NetworkLogger.log(decodingError: error, type: type)
            throw APIError.decoding
        }
    }
}
