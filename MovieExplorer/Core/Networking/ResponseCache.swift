import CryptoKit
import Foundation

/// Last successful response of each request, so screens still load offline.
nonisolated struct ResponseCache: Sendable {
    private let directory: URL

    init(directory: URL = .cachesDirectory.appending(path: "ResponseCache")) {
        self.directory = directory
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    func save(_ data: Data, for url: URL) {
        try? data.write(to: fileURL(for: url), options: .atomic)
    }

    func data(for url: URL) -> Data? {
        try? Data(contentsOf: fileURL(for: url))
    }

    private func fileURL(for url: URL) -> URL {
        let hash = SHA256.hash(data: Data(url.absoluteString.utf8))
        return directory.appending(path: hash.map { String(format: "%02x", $0) }.joined())
    }
}
