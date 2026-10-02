import Foundation
@testable import MovieExplorer

struct MockNetworkSession: NetworkSession {
    let status: Int
    var body = ""

    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = request.url,
              let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil)
        else { throw URLError(.badURL) }
        return (Data(body.utf8), response)
    }
}
