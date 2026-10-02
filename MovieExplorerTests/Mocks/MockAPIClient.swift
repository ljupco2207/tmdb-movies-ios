@testable import MovieExplorer

/// Returns whatever the handler gives for an endpoint, so view models are tested without the network.
final class MockAPIClient: APIClientProtocol {
    private let handler: @Sendable (Endpoint) throws -> any Sendable

    init(handler: @escaping @Sendable (Endpoint) throws -> any Sendable) {
        self.handler = handler
    }

    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        guard let value = try handler(endpoint) as? T else { throw APIError.decoding }
        return value
    }
}
