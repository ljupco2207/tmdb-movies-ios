import Observation

@Observable
final class TrendingViewModel {
    private(set) var movies: [Movie] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let api: APIClientProtocol

    init(api: APIClientProtocol) {
        self.api = api
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let page: MoviePage = try await api.request(.trending(page: 1))
            movies = page.results
        } catch {
            errorMessage = "Couldn't load movies."
        }
    }
}
