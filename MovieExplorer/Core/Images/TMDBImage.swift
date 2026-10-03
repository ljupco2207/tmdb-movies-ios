import Foundation

nonisolated enum TMDBImage {
    enum Kind {
        case backdrop
        case poster

        /// From TMDB's /configuration; hard-coded because they rarely change.
        var widths: [Int] {
            switch self {
            case .backdrop: [300, 780, 1280]
            case .poster: [92, 154, 185, 342, 500, 780]
            }
        }
    }

    /// Smallest width that covers the view, capped at the largest one ("original" can be a multi-MB 4K image).
    static func size(forPixelWidth pixelWidth: Double, kind: Kind) -> String {
        let width = kind.widths.first {
            Double($0) >= pixelWidth
        } ?? kind.widths[kind.widths.count - 1]
        return "w\(width)"
    }

    static func url(path: String?, kind: Kind, pixelWidth: Double) -> URL? {
        guard let path, pixelWidth > 0 else { return nil }
        return APIConfig.imageBaseURL
            .appending(path: size(forPixelWidth: pixelWidth, kind: kind))
            .appending(path: path)
    }
}
