import Observation

@Observable
final class TrendingViewModel {
    private(set) var movies: [Movie] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private var page = 0
    private var totalPages = 1
    private let api: APIClientProtocol

    var hasMorePages: Bool { page < totalPages }

    init(api: APIClientProtocol) {
        self.api = api
    }

    func loadNextPage() async {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result: Page<Movie> = try await api.request(.trending(page: page + 1))
            // Trending can repeat a movie across pages; duplicate IDs would crash the diffable data source.
            var seen = Set(movies.map(\.id))
            movies += result.results.filter { seen.insert($0.id).inserted }
            page = result.page
            totalPages = result.totalPages
        } catch {
            errorMessage = "Couldn't load movies."
        }
    }
}
