/// Movies and series name the same fields differently.
nonisolated protocol MediaDisplayable {
    var title: String? { get }
    var name: String? { get }
    var releaseDate: String? { get }
    var firstAirDate: String? { get }
}

nonisolated extension MediaDisplayable {
    var displayTitle: String { title ?? name ?? "" }

    var year: String? {
        guard let date = releaseDate ?? firstAirDate, date.count >= 4 else { return nil }
        return String(date.prefix(4))
    }
}
