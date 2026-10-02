import Foundation

nonisolated protocol NetworkSession: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse)
}

nonisolated extension URLSession: NetworkSession {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
