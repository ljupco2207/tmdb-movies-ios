import Foundation
import SwiftData

/// Stores what the Favorites list shows, so it also works offline.
@Model
final class Favorite {
    @Attribute(.unique) var key: String
    var tmdbID: Int
    var mediaTypeRawValue: String
    var title: String
    var posterPath: String?
    var year: String?
    var addedAt: Date

    var mediaType: MediaType {
        MediaType(rawValue: mediaTypeRawValue) ?? .movie
    }

    init(item: FavoriteItem, addedAt: Date = .now) {
        key = item.key
        tmdbID = item.id
        mediaTypeRawValue = item.type.rawValue
        title = item.title
        posterPath = item.posterPath
        year = item.year
        self.addedAt = addedAt
    }
}

nonisolated struct FavoriteItem: Equatable, Sendable {
    let id: Int
    let type: MediaType
    let title: String
    let posterPath: String?
    let year: String?

    var key: String { Self.key(id: id, type: type) }

    static func key(id: Int, type: MediaType) -> String {
        "\(type.rawValue)-\(id)"
    }
}

extension FavoriteItem {
    init(details: MediaDetails, type: MediaType) {
        self.init(id: details.id, type: type, title: details.displayTitle, posterPath: details.posterPath, year: details.year)
    }
}
