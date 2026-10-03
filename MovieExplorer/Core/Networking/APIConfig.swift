import Foundation

/// Values come from Config/Dev.xcconfig or Config/Prod.xcconfig via Info.plist; the scheme picks which.
nonisolated enum APIConfig {
    static let baseURL = url(for: "APIBaseURL")
    static let imageBaseURL = url(for: "ImageBaseURL")
    static let accessToken = value(for: "APIAccessToken")

    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty else {
            fatalError("\(key) is missing from Info.plist; check Config/*.xcconfig")
        }
        return value
    }

    private static func url(for key: String) -> URL {
        guard let url = URL(string: value(for: key)) else {
            fatalError("\(key) is not a valid URL; check Config/*.xcconfig")
        }
        return url
    }
}
