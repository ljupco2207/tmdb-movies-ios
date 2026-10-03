import Foundation

nonisolated extension Int {
    /// Locale-formatted number with a singular or plural noun: "1 season", "25,000 votes".
    func counted(_ singular: String, plural: String? = nil) -> String {
        "\(formatted()) \(self == 1 ? singular : plural ?? singular + "s")"
    }
}
