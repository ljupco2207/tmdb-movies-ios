import Foundation

nonisolated enum TMDBImage {
    /// From TMDB's /configuration; hard-coded because they rarely change.
    static let backdropWidths = [300, 780, 1280]

    /// Smallest width that covers the view, capped at the largest one ("original" can be a multi-MB 4K image).
    static func backdropSize(forPixelWidth pixelWidth: Double) -> String {
        let width = backdropWidths.first {
            Double($0) >= pixelWidth
        } ?? backdropWidths[backdropWidths.count - 1]
        return "w\(width)"
    }

    static func backdropURL(path: String?, pixelWidth: Double) -> URL? {
        guard let path, pixelWidth > 0 else { return nil }
        return APIConfig.imageBaseURL
            .appending(path: backdropSize(forPixelWidth: pixelWidth))
            .appending(path: path)
    }
}
