import Foundation
import os

nonisolated enum NetworkLogger {
    static let isEnabled = ProcessInfo.processInfo.environment["NETWORK_LOGGING"] == "1"

    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "MovieExplorer", category: "Network")

    static func log(_ request: URLRequest, statusCode: Int, duration: Duration) {
        guard isEnabled else { return }
        let milliseconds = Int(duration / .milliseconds(1))
        logger.debug("\(describe(request), privacy: .public) → \(statusCode) (\(milliseconds) ms)")
    }

    static func log(_ request: URLRequest, error: any Error) {
        guard isEnabled else { return }
        logger.error("\(describe(request), privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
    }

    static func log(decodingError: any Error, type: Any.Type) {
        guard isEnabled else { return }
        let reason = String(describing: decodingError)
        logger.error("Decoding \(String(describing: type), privacy: .public) failed: \(reason, privacy: .public)")
    }

    /// Method, path and query only; headers are left out so the token never reaches the console.
    private static func describe(_ request: URLRequest) -> String {
        let method = request.httpMethod ?? "GET"
        guard let url = request.url else { return method }
        let query = url.query().map { "?\($0)" } ?? ""
        return "\(method) \(url.path())\(query)"
    }
}
