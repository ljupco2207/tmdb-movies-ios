import Observation

@Observable
final class DetailsViewModel {
    enum State {
        case loading
        case loaded(MovieDetails)
        case failed
    }

    private(set) var state: State = .loading

    private let movieID: Int
    private let api: APIClientProtocol

    init(movieID: Int, api: APIClientProtocol) {
        self.movieID = movieID
        self.api = api
    }

    func load() async {
        state = .loading
        do {
            state = .loaded(try await api.request(.movieDetails(id: movieID)))
        } catch {
            state = .failed
        }
    }
}
