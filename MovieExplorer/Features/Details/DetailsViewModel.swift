import Observation

@Observable
final class DetailsViewModel {
    enum State {
        case loading
        case loaded(MediaDetails)
        case failed
    }

    private(set) var state: State = .loading

    private let id: Int
    private let type: MediaType
    private let api: APIClientProtocol

    init(id: Int, type: MediaType, api: APIClientProtocol) {
        self.id = id
        self.type = type
        self.api = api
    }

    func load() async {
        state = .loading
        let endpoint: Endpoint = type == .movie ? .movieDetails(id: id) : .tvDetails(id: id)
        do {
            state = .loaded(try await api.request(endpoint))
        } catch {
            state = .failed
        }
    }
}
