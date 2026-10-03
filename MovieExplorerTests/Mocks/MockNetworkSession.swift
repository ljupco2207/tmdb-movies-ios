import Foundation
@testable import MovieExplorer

struct MockNetworkSession: NetworkSession {
    var status = 200
    var body = ""
    var error: URLError?

    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if let error { throw error }
        guard let url = request.url,
              let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil)
        else { throw URLError(.badURL) }
        return (Data(body.utf8), response)
    }
}
