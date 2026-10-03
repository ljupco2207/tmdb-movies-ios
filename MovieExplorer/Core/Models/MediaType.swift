/// TMDB ids are only unique within one type, so an id always needs its MediaType.
nonisolated enum MediaType: String, Hashable, Sendable {
    case movie
    case tv
}
