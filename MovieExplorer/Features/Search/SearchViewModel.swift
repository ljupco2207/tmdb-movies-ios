import Foundation
import Observation

@Observable
final class SearchViewModel {
    var query = "" {
        didSet { scheduleSearch() }
    }
    var mediaType: MediaType = .movie {
        didSet { scheduleSearch() }
    }

    private(set) var results: [SearchResult] = []
    private(set) var resultsType: MediaType = .movie
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var searchTask: Task<Void, Never>?

    private let api: APIClientProtocol
    private let debounce: Duration

    init(api: APIClientProtocol, debounce: Duration = .milliseconds(400)) {
        self.api = api
        self.debounce = debounce
    }

    /// Throttling: each change cancels the previous search and starts a new one once typing pauses.
    private func scheduleSearch() {
        searchTask?.cancel()

        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            results = []
            isLoading = false
            errorMessage = nil
            return
        }

        isLoading = true
        let type = mediaType
        searchTask = Task {
            try? await Task.sleep(for: debounce)
            guard !Task.isCancelled else { return }
            await search(query, type: type)
        }
    }

    private func search(_ query: String, type: MediaType) async {
        errorMessage = nil
        let endpoint: Endpoint = switch type {
        case .movie: .searchMovies(query: query)
        case .tv: .searchTV(query: query)
        }

        do {
            let page: Page<SearchResult> = try await api.request(endpoint)
            guard !Task.isCancelled else { return }
            results = page.results
            resultsType = type
        } catch {
            guard !Task.isCancelled else { return }
            results = []
            errorMessage = "Couldn't load results."
        }
        isLoading = false
    }
}
